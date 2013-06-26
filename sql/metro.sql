-- create temporaly table with colors according to metro line name
create temp table colors(name char(7), color char(6));
insert into colors values ('Metro A', '007f00');
insert into colors values ('Metro B', '827f00');
insert into colors values ('Metro C', '7f0000');

-- select name, geometry, symbol and color of each station
select point.name,
        ST_Transform(point.way,4326),           -- data are in 3857
        'rail-underground' as "marker-symbol",  -- add symbol
        colors.color as "marker-color"          -- add color
    from planet_osm_point as point
    INNER JOIN                                  -- color join
        planet_osm_line as line ON (ST_Distance(point.way, line.way) < 1)
    INNER JOIN
        colors ON line.name = colors.name,    
    planet_osm_polygon as polygon             
    where
        point.railway='station' and
        line.railway = 'subway' AND
        polygon.name = 'Praha' AND 
        polygon.admin_level='8' AND 
        (st_within(point.way, polygon.way)) -- only points insde of Prague city
    GROUP BY
        point.way,point.name, colors.color
