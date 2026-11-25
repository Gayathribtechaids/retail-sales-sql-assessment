# Dataset import note

The worksheet refers to an attached retail dataset, but the files available for this
GitHub package contained the completed worksheet, query-output document, and
PowerPoint only. No CSV/SQL data dump was present.

To reproduce the results from a fresh database:
1. Open DB Fiddle and select **MySQL 8.0**.
2. Run `sql/execution_order/00_create_starter_tables.sql`.
3. Import or insert the six source tables from the original assessment dataset:
   `Customers`, `Stores`, `Products`, `Orders`, `OrderItems`, and `Returns`.
4. Run the numbered scripts in `sql/execution_order/` from Q1 onward.
5. Compare your result sets with `outputs/Query_Outputs.docx`.

Do not invent or manually recreate missing rows from screenshots: the screenshots
show selected query outputs, not the complete source dataset.
