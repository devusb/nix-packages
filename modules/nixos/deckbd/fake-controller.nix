# A uinput device carrying the Steam Deck's evdev identity, which is all deckbd
# matches on. Waits for a systemd password prompt, then types "19" and enter.
{ pkgs }:
let
  python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeText "deckbd-test-controller.py" ''
    import os
    import sys
    import time

    from evdev import InputDevice, UInput, ecodes as e

    # Everything deckbd maps, so it recognises us as a controller.
    BUTTONS = [
        e.BTN_DPAD_UP, e.BTN_DPAD_DOWN, e.BTN_DPAD_LEFT, e.BTN_DPAD_RIGHT,
        e.BTN_A, e.BTN_B, e.BTN_X, e.BTN_Y,
        e.BTN_TL, e.BTN_TR, e.BTN_TL2, e.BTN_TR2,
    ]

    # deckbd turns these into "19" and enter.
    PRESSES = [e.BTN_DPAD_UP, e.BTN_TL, e.BTN_TR2]

    ASK_DIR = "/run/systemd/ask-password"


    def report(message):
        print("DECKBD-TEST: " + message, flush=True)
        with open("/run/deckbd-test", "w") as handle:
            handle.write(message + "\n")


    def wait_for(predicate, tries=120):
        for _ in range(tries):
            value = predicate()
            if value:
                return value
            time.sleep(0.5)
        return None


    def make_controller():
        try:
            return UInput(
                {e.EV_KEY: BUTTONS},
                name="Steam Deck",
                vendor=0x28DE,
                product=0x1205,
                bustype=e.BUS_USB,
                version=0x0110,
            )
        except OSError:
            return None


    def find_deckbd():
        # deckbd publishes its keystrokes on a uinput device of its own.
        for entry in sorted(os.listdir("/dev/input")):
            if not entry.startswith("event"):
                continue
            try:
                device = InputDevice("/dev/input/" + entry)
            except OSError:
                continue
            if device.name == "deckbd":
                return device
            device.close()
        return None


    def prompt_waiting():
        # systemd-ask-password advertises a prompt as ask-password/ask.*
        try:
            return any(name.startswith("ask.") for name in os.listdir(ASK_DIR))
        except OSError:
            return False


    def press_all(controller):
        for button in PRESSES:
            controller.write(e.EV_KEY, button, 1)
            controller.syn()
            time.sleep(0.05)
            controller.write(e.EV_KEY, button, 0)
            controller.syn()
            time.sleep(0.25)


    def main():
        controller = wait_for(make_controller)
        if controller is None:
            report("FAIL could not create the fake controller")
            return 1
        report("fake controller created")

        if wait_for(find_deckbd) is None:
            report("FAIL deckbd never claimed the controller")
            return 1
        report("deckbd claimed the controller")

        if not wait_for(prompt_waiting, tries=240):
            report("FAIL no password prompt appeared")
            return 1
        report("password prompt is waiting")

        press_all(controller)
        report("PASS")
        return 0


    if __name__ == "__main__":
        sys.exit(main())
  '';
in
{
  command = "${python}/bin/python3 ${script}";

  # storePaths copies what it is given, and the env's bin/python3 is a symlink
  # into the interpreter's own store path, so both have to be listed.
  storePaths = [
    python
    pkgs.python3
    script
  ];
}
