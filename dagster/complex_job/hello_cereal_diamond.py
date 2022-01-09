import csv

import requests
import dagster
from dagster import get_dagster_logger, job, op


def _is_list_of_dicts(_, value):
    return isinstance(value, list) and all(
        isinstance(element, dict) for element in value)


def _less_simple_data_frame_type_check(_, value):
    if not isinstance(value, list):
        return dagster.TypeCheck(
            success=False,
            description=(f"LessSimpleDataFrame should be a list of dicts, "
                         f"got {type(value)}"),
        )

    fields = [field for field in value[0].keys()]

    for i in range(len(value)):
        row = value[i]
        idx = i + 1
        if not isinstance(row, dict):
            return dagster.TypeCheck(
                success=False,
                description=(f"LessSimpleDataFrame should be a list of dicts, "
                             f"got {type(row)} for row {idx}"),
            )
        row_fields = [field for field in row.keys()]
        if fields != row_fields:
            return dagster.TypeCheck(
                success=False,
                description=(
                    f"Rows in LessSimpleDataFrame should have the same fields,"
                    f" got {row_fields} "
                    f"for row {idx}, expected {fields}"),
            )

    return dagster.TypeCheck(
        success=True,
        description="LessSimpleDataFrame summary statistics",
        metadata={
            "n_rows": len(value),
            "n_cols": len(value[0].keys()) if len(value) > 0 else 0,
            "column_names":
            str(list(value[0].keys()) if len(value) > 0 else []),
        },
    )


SimpleDataFrame = dagster.DagsterType(
    name="SimpleDataFrame",
    # type_check_fn=_is_list_of_dicts,
    type_check_fn=_less_simple_data_frame_type_check,
    description=("A naive representation of a data frame, e.g., "
                 "as returned by csv.DictReader. "))


def _is_url(_, value):
    url_prefixes = ['http://', 'https://']
    return isinstance(value, str) and any(value.lower().startswith(prefix)
                                          for prefix in url_prefixes)


URLType = dagster.DagsterType(name="URLType",
                              type_check_fn=_is_url,
                              description="A URL string.")


# The Ops and Jobs
# How do we check the config type by our custom type?
@op(
    config_schema={'url': str},
    # config_schema={'url': URLType},  # Invalid method.
    out=dagster.Out(SimpleDataFrame))
def download_csv(context):
    response = requests.get(context.op_config['url'])
    lines = response.text.split("\n")
    return [row for row in csv.DictReader(lines)]


@op
def download_cereals():
    response = requests.get("https://docs.dagster.io/assets/cereal.csv")
    lines = response.text.split("\n")
    return [row for row in csv.DictReader(lines)]


@op(ins={
    'cereals': dagster.In(SimpleDataFrame),
})
def find_highest_calorie_cereal(cereals):
    sorted_cereals = list(
        sorted(cereals, key=lambda cereal: cereal["calories"]))
    return sorted_cereals[-1]["name"]


@op(ins={
    'cereals': dagster.In(SimpleDataFrame),
})
def find_highest_protein_cereal(cereals):
    sorted_cereals = list(sorted(cereals,
                                 key=lambda cereal: cereal["protein"]))
    return sorted_cereals[-1]["name"]


@op
def display_results(most_calories, most_protein):
    logger = get_dagster_logger()
    logger.info(f"Most caloric cereal: {most_calories}")
    logger.info(f"Most protein-rich cereal: {most_protein}")


@job
def diamond():
    cereals = download_csv()
    display_results(
        most_calories=find_highest_calorie_cereal(cereals),
        most_protein=find_highest_protein_cereal(cereals),
    )


if __name__ == '__main__':
    result = diamond.execute_in_process(
        run_config={
            "ops": {
                "download_csv": {
                    "config": {
                        "url": "https://docs.dagster.io/assets/cereal.csv"
                    }
                }
            }
        })
