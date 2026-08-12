{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  jsonpath-ng' = python3.pkgs.jsonpath-ng.overridePythonAttrs (old: {
    version = "1.8.0";
    src = fetchFromGitHub {
      owner = "h2non";
      repo = "jsonpath-ng";
      tag = "v1.8.0";
      hash = "sha256-soCSMOHJpAM/tOaydvv8tGS/VewtSMBteDNipSPttI0=";
    };
    nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ python3.pkgs.hypothesis ];
  });
in
python3.pkgs.buildPythonApplication rec {
  pname = "dlt";
  version = "1.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dlt-hub";
    repo = "dlt";
    rev = version;
    hash = "sha256-e9V14iq4qqL0ZH3xOjc6tm9bBpgyarnrAe/8CJT/Tdg=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    fsspec
    gitpython
    giturlparse
    hexbytes
    humanize
    jsonpath-ng'
    orjson
    packaging
    pathvalidate
    pendulum
    pluggy
    pytz
    pyyaml
    requests
    requirements-parser
    rich-argparse
    semver
    setuptools
    simplejson
    sqlglot
    tenacity
    tomlkit
    typing-extensions
    tzdata
  ];

  optional-dependencies = with python3.pkgs; {
    athena = [
      botocore
      pyarrow
      pyathena
      s3fs
    ];
    az = [
      adlfs
    ];
    bigquery = [
      db-dtypes
      gcsfs
      google-cloud-bigquery
      grpcio
      pyarrow
    ];
    cli = [
      cron-descriptor
      pip
      pipdeptree
    ];
    clickhouse = [
      adlfs
      clickhouse-connect
      clickhouse-driver
      gcsfs
      pyarrow
      s3fs
    ];
    databricks = [
      databricks-sdk
      databricks-sql-connector
    ];
    dbml = [
      pydbml
    ];
    deltalake = [
      deltalake
      pyarrow
    ];
    dremio = [
      pyarrow
    ];
    duckdb = [
      duckdb
    ];
    filesystem = [
      botocore
      s3fs
    ];
    gcp = [
      db-dtypes
      gcsfs
      google-cloud-bigquery
      grpcio
    ];
    gs = [
      gcsfs
    ];
    lancedb = [
      lancedb
      pyarrow
      tantivy
    ];
    motherduck = [
      duckdb
      pyarrow
    ];
    mssql = [
      pyodbc
    ];
    parquet = [
      pyarrow
    ];
    postgis = [
      psycopg2-binary
    ];
    postgres = [
      psycopg2-binary
    ];
    pyiceberg = [
      pyarrow
      pyiceberg
      sqlalchemy
    ];
    qdrant = [
      qdrant-client
    ];
    redshift = [
      psycopg2-binary
    ];
    s3 = [
      botocore
      s3fs
    ];
    sftp = [
      paramiko
    ];
    snowflake = [
      snowflake-connector-python
    ];
    sql_database = [
      sqlalchemy
    ];
    sqlalchemy = [
      alembic
      sqlalchemy
    ];
    synapse = [
      adlfs
      pyarrow
      pyodbc
    ];
    weaviate = [
      weaviate-client
    ];
    workspace = [
      duckdb
      ibis-framework
      marimo
      pandas
      pyarrow
    ];
  };

  pythonImportsCheck = [
    "dlt"
  ];

  meta = {
    description = "Data load tool (dlt) is an open source Python library that makes data loading easy";
    homepage = "https://github.com/dlt-hub/dlt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "dlt";
  };
}
