{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dlt";
  version = "1.18.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dlt-hub";
    repo = "dlt";
    rev = version;
    hash = "sha256-T+4eOrVU8nm8pGroPKm6sVLl4YkpPaHVTimlY2czoW0=";
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
    jsonpath-ng
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
