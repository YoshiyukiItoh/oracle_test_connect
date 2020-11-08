set timing on;
drop table test;

create table test (item1 int);

insert into test values (1);
insert into test values (2);
insert into test values (3);
insert into test values (4);
insert into test values (5);
insert into test values (6);
insert into test values (7);
insert into test values (8);
insert into test values (9);
insert into test values (10);

select count(*) from test;
commit;

insert into test (item1) select a.item1 item1 from test a , test b , test c , test d , test e, test f, test g, test h, test i;
select count(*) from test;
quit;
