# AI Usage Disclosure

This project was implemented by me, with ChatGPT used as a development assistant throughout the assessment.

## How AI was Used

AI was used to assist with:

- Explaining SQL and PostgreSQL concepts during development.
- Reviewing SQL queries and suggesting improvements.
- Debugging Python and SQL errors encountered while building the pipeline.
- Reviewing data modeling decisions for the fact and dimension tables.
- Improving project documentation, including:
  - README.md
  - Data Quality Report
  - DECISIONS.md
  - Insight Memo
- Refining wording and formatting for documentation.

## What I Implemented Myself

The following work was completed by me:

- Designing the overall pipeline architecture.
- Building the Raw, Staging, and Mart layers.
- Implementing the Python ingestion pipeline.
- Creating SQL models for:
  - `stg_*` tables
  - `marts.fct_orders`
  - `marts.dim_sellers`
  - `marts.dim_products`
- Investigating data quality findings and deciding how to handle them.
- Writing and validating all analytical SQL used in the insight memo.
- Running the pipeline, validating outputs, and debugging issues until the solution worked end to end.

## Verification

All AI-generated suggestions were reviewed, modified where necessary, executed locally, and validated against the dataset before being included in the final solution. No generated code or documentation was accepted without testing and verification.