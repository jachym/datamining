-- create temporaly table with colors according to metro line name
create temp table colors(name char(7), color char(6));
insert into colors values ('Metro A', '007f00');
insert into colors values ('Metro B', '827f00');
insert into colors values ('Metro C', '7f0000');

-- select name, geometry, symbol and color of each station
select point.name,
        ST_Transform(                           -- data are in 3857
            ST_Centroid(                        -- there are more metro entrances, just one point needed
                ST_Union(point.way)             -- join all entrances with same name into one multi-point feature
            ),
            4326
        ),
        'rail-underground' as "marker-symbol",  -- add symbol
        colors.color as "marker-color"          -- add color
    from planet_osm_point as point
    INNER JOIN                                  -- color join
        colors ON point.name ilike '%'||colors.name,    
     planet_osm_polygon as polygon              
    where polygon.name = 'Praha' AND 
        polygon.admin_level='8' AND 
        point.railway = 'subway_entrance' AND 
        (st_within(point.way, polygon.way)) AND -- only points insde of Prague city
        point.name is not null
    GROUP BY
        point.name, colors.color
