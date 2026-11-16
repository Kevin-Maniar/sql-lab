use school_db;
select * from marks;
select * from subjects;
select * from students;

alter table marks add foreign key (roll_no) references students(roll_no);
alter table marks add foreign key (subject_id) references subjects(subject_id);

insert into marks (roll_no,subject_id,marks_obtained) values
(99,45,89);

-- 14:56:26	insert into marks (roll_no,subject_id,marks_obtained) values (99,45,89)	
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails 
-- (`school_db`.`marks`, CONSTRAINT `marks_ibfk_1` FOREIGN KEY (`roll_no`) REFERENCES `students` (`roll_no`))	0.016 sec



 