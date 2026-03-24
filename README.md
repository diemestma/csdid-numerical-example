# csdid-numerical-example

Cálculo manual de las medidas de agregación simple y grupal del ATT, y del error estándar Jackknife agrupado, replicando los resultados de los comandos `csdid` y `csdidjack` en Stata.

## Contenido

- **simulacion_csdid.dta**: datos simulados para DiD escalonado (4 clústeres, 3 periodos, 2 observaciones por clúster-periodo).
- **csdid_manual.do**: código para replicar manualmente:
  - El ATT simple y grupal (grupo de control: nunca tratados).
  - El error estándar Jackknife agrupado del ATT simple.
