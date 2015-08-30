UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';
drop database template1;
create database template1 with owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;
UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';
