#!/bin/sh

ogr2ogr -f GeoJSON metro.json PG:dbname=osm_cr -sql "`cat metro.sql`"
