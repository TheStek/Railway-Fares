import tabula
import pandas as pd

tables = tabula.read_pdf("http://data.atoc.org/sites/all/themes/atoc/files/RSPS5045.pdf", pages = 60,  multiple_tables = True)
print(tables)