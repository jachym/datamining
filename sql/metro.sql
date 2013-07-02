select point.name, ST_Transform(point.way, 4326), 
    'rail-underground' as "marker-symbol", 
    CASE WHEN line.name = 'Metro A' THEN '007f00' 
         WHEN line.name = 'Metro B' THEN '827f00' 
         WHEN line.name = 'Metro C' THEN '7f0000' 
    ELSE NULL 
    END "marker-color"
  from planet_osm_point as point
 INNER JOIN planet_osm_line as line
    ON (ST_Distance(point.way, line.way) < 1)
 where point.railway = 'station'
   and line.railway = 'subway'
   AND ST_WITHIN(
           point.way,(
            SELECT ST_UNION(polygon.way)
                  FROM planet_osm_polygon as polygon
                 WHERE polygon.NAME = 'Praha'
                   and polygon.admin_level = '8'
                   )
           )
 GROUP BY point.way, point.name
