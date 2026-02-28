import pandas as pd

df = pd.read_csv("retail_store_inventory 75k.csv", sep=";")

# convertir coma decimal
df["Demand Forecast"] = df["Demand Forecast"].str.replace(",", ".").astype(float)
df["Price"] = df["Price"].str.replace(",", ".").astype(float)
df["Competitor Pricing"] = df["Competitor Pricing"].str.replace(",", ".").astype(float)

# fecha
df["Date"] = pd.to_datetime(df["Date"], dayfirst=True)

# dimensiones
dim_store = df[["Store ID","Region"]].drop_duplicates()
dim_product = df[["Product ID","Category"]].drop_duplicates()
dim_date = df[["Date"]].drop_duplicates()

df.to_csv("fact_table.csv", index=False)