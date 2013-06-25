select point.name,
        ST_Transform(
            ST_Centroid(
                ST_Union(point.way)
            ),
            4326
        ),
        'marker-symbol' as "rail-underground"
    from planet_osm_point as point, 
         planet_osm_polygon as polygon 
    where polygon.name = 'Praha' AND 
        polygon.admin_level='8' AND 
        point.railway = 'subway_entrance' AND 
        (st_within(point.way, polygon.way)) AND 
        point.name is not null
    GROUP BY
        point.name
