# VaxMe

![image](https://user-images.githubusercontent.com/3444/115124840-6b597b00-9f92-11eb-9f32-80916b87f1be.png)

## Running locally

```console
# install & run
nvm use
make run
```

### build:
```console
make dist
```

## Sources

[Postal code boundaries](https://www150.statcan.gc.ca/n1/en/catalogue/92-179-X)

## Converting boundary Shapefiles to geoJson

### install `ogr2ogr` for coordinate conversion

- download & install GDAL from https://www.kyngchaos.com/software/frameworks/
```bash
echo 'export PATH=/Library/Frameworks/GDAL.framework/Programs:$PATH' >> ~/.bash_profile
source ~/.bash_profile
 ```

### convert coordinates:
```bash
cd data
# convert co-ordinates to lat/lng
ogr2ogr -t_srs EPSG:4326 -f geoJSON -lco COORDINATE_PRECISION=9 postal_codes.json lfsa000a16a_e/lfsa000a16a_e.shp
```

### simplify the shape (for faster lookups)
- go to https://mapshaper.org/
- upload `postal_codes.json`
- simplify (6-12% is a good starting range)
- export, overwrite original file

### Fix geojson errors
```bash
# detect errors
ogrinfo -dialect sqlite -sql "select * from \"postal_codes\" where ST_IsValid(geometry)=0" postal_codes.json

# fix errors
ogr2ogr -f GeoJSON -dialect sqlite -sql "select ST_MakeValid(geometry),PRNAME,PRUID,CFSAUID from \"postal_codes\"" fixed_postal_codes.json postal_codes.json

# remove original, rename fixed, gzip
rm postal_codes.json
mv fixed_postal_codes.json postal_codes.json
gzip postal_codes.json
```
