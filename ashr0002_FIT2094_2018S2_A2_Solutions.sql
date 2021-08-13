--Student ID: 29389356
--Student Fullname: Anisha Shrestha
--Tutor Name: Roushan Mahmud

/*  --- COMMENTS TO YOUR MARKER --------

1. Drop table command for the table created to change the live database for question 4.3 and has been placed in 
Q1.2.

2. For 4.2 it is assumed that branches will have many returns from loans and one return will just belong to one 
branch.

3. Q 4.3- As mentioned in the specification as managers and branches have a many to many relationship thus a bridging 
table is created called manager_type( where a branch can have many manager types and a manager of a particular type
will just belong to one branch, and managers can be of one or many manager type while a particluar type of manager
in a branch will just point at one manager. 
 
4. Q 3.2 as mentioned in the assumtions as branches dont have additional copies added exact for the ones added at 2.1
    it is retrieved using the branch_code and the book_call_no

5. For the reserve table, When a book is reserved for a borrower the record of the issued reserve will be deleted
when the book is made avaliable to the borrower, thus a borrower can only have one active reserve for a particular 
book copy from a particular branch in a particular time. 

6. Q 3.2 as no other copies of the book with call id 005. 74 C822D 2018 is added to any of the branches the bc_id 
is retrieved using branch_code and book_call_no. 


*/

--Q1
/*
1.1
Add to your solutions script, the CREATE TABLE and CONSTRAINT definitions which are missing from the 
FIT2094_2018S2_A2_Schema_Start.sql script. You MUST use the relation and attribute names shown in the data model above 
to name tables and attributes which you add.
*/SET ECHO ON

--create table for book_copy
CREATE TABLE book_copy (
    branch_code         NUMERIC(2) NOT NULL,
    bc_id               NUMERIC(6) NOT NULL,
    bc_purchase_price   NUMERIC(7,2) NOT NULL,
    bc_reserve_flag     CHAR(1) NOT NULL,
    book_call_no        VARCHAR(20) NOT NULL
);
-- adding comments into the fields for book_copy

COMMENT ON COLUMN book_copy.branch_code IS
    'Branch number';

COMMENT ON COLUMN book_copy.bc_id IS
    'Book copy number';

COMMENT ON COLUMN book_copy.bc_purchase_price IS
    'Book copy price';

COMMENT ON COLUMN book_copy.bc_reserve_flag IS
    'Type of flag';

COMMENT ON COLUMN book_copy.book_call_no IS
    'Titles call number - identifies a title';

--Changing table structure
--adding primary keys

ALTER TABLE book_copy ADD CONSTRAINT book_copy_pk PRIMARY KEY ( bc_id,
                                                                branch_code );
--adding foreign keys 

ALTER TABLE book_copy
    ADD CONSTRAINT houses FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE book_copy
    ADD CONSTRAINT has FOREIGN KEY ( book_call_no )
        REFERENCES book_detail ( book_call_no );
        
--adding check constraint

ALTER TABLE book_copy
    ADD CONSTRAINT bc_reserve_chk CHECK ( bc_reserve_flag IN (
        'Y',
        'N'
    ) );

--Creating a table for reserve

CREATE TABLE reserve (
    branch_code                NUMERIC(2) NOT NULL,
    bc_id                      NUMERIC(6) NOT NULL,
    reserve_date_time_placed   DATE NOT NULL,
    bor_no                     NUMERIC(6) NOT NULL
);

--adding comments into the field

COMMENT ON COLUMN reserve.branch_code IS
    'Branch number';

COMMENT ON COLUMN reserve.bc_id IS
    'Local book copy number';

COMMENT ON COLUMN reserve.reserve_date_time_placed IS
    'Date and time reserve placed';

COMMENT ON COLUMN reserve.bor_no IS
    'Borrower identifier';

 
/*changing the structure of reserve table*/

--adding primary key for reserve

ALTER TABLE reserve
    ADD CONSTRAINT reserve_pk PRIMARY KEY ( branch_code,
                                            bc_id,
                                            reserve_date_time_placed );
--adding foreign keys to reserve

ALTER TABLE reserve
    ADD CONSTRAINT is_reserved FOREIGN KEY ( branch_code,
                                             bc_id )
        REFERENCES book_copy ( branch_code,
                               bc_id );
-- adding foreign key to reserve

ALTER TABLE reserve
    ADD CONSTRAINT reserves FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );
        

--Create table for loan    

CREATE TABLE loan (
    branch_code               NUMERIC(2) NOT NULL,
    bc_id                     NUMERIC(6) NOT NULL,
    loan_date_time            DATE NOT NULL,
    loan_due_date             DATE NOT NULL,
    loan_actual_return_date   DATE,
    bor_no                    NUMERIC(6) NOT NULL
);
--adding comments to the fields

COMMENT ON COLUMN loan.branch_code IS
    'Branch number';

COMMENT ON COLUMN loan.bc_id IS
    'Local book copy number';

COMMENT ON COLUMN loan.loan_date_time IS
    'Loan date and time';

COMMENT ON COLUMN loan.loan_due_date IS
    'Loan due date';

COMMENT ON COLUMN loan.loan_actual_return_date IS
    'Actual return date';

COMMENT ON COLUMN loan.bor_no IS
    'Borrower identifier';

--changing the structure of the table

--adding primary keys to loan

ALTER TABLE loan
    ADD CONSTRAINT loan_pk PRIMARY KEY ( branch_code,
                                         bc_id,
                                         loan_date_time );

-- adding foreign keys to loan

ALTER TABLE loan
    ADD CONSTRAINT borrowed FOREIGN KEY ( branch_code,
                                          bc_id )
        REFERENCES book_copy ( branch_code,
                               bc_id );

ALTER TABLE loan
    ADD CONSTRAINT borrows FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );
             
/*
1.2
Add the full set of DROP TABLE statements to your solutions script. In completing this section you must not use the CASCADE 
CONSTRAINTS clause as part of your DROP TABLE statement (you should include the PURGE clause).
 
*/

-- statements for droping tables

DROP TABLE bd_author PURGE;

DROP TABLE author PURGE;

DROP TABLE bd_subject PURGE;

DROP TABLE manager_type PURGE; -- table created to meet the specifications of task 4.3 

DROP TABLE subject PURGE;

DROP TABLE reserve PURGE;

DROP TABLE loan PURGE;

DROP TABLE book_copy PURGE;

DROP TABLE book_detail PURGE;

DROP TABLE publisher PURGE;

DROP TABLE borrower PURGE;

DROP TABLE branch PURGE;

DROP TABLE manager PURGE;

--Q2
/*
2.1
MonLib has just purchased its first 3 copies of a recently released edition of a book. Readers of this book will learn about 
the subjects "Database Design" and "Database Management". 

Some of  the details of the new book are:

	      	Call Number: 005.74 C822D 2018
Title: Database Systems: Design, Implementation, and Management
	      	Publication Year: 2018
	      	Edition: 13
	      	Publisher: Cengage
	Authors: Carlos CORONEL (author_id = 1 ) and 
   Steven MORRIS  (author_id = 2)  	      	
Price: $120
	
You may make up any other reasonable data values you need to be able to add this book.

Each of the 3 MonLib branches listed below will get a single copy of this book, the book will be available for borrowing 
(ie not on counter reserve) at each branch:

		Clayton (Ph: 8888888881)
		Oakleigh (Ph: 8888888882)
        Mulgrave (Ph: 8888888883)

Your are required to treat this add of the book details and the three copies as a single transaction.
*/

--adding inserts into book_details

INSERT INTO book_detail VALUES (
    '005.74 C822D 2018',
    'Database Systems: Design, Implementation, and Management',
    'R',
    1260,
    TO_DATE('2018','YYYY'),
    '13',
    (
        SELECT
            pub_id
        FROM
            publisher
        WHERE
            pub_name = 'Cengage'
    )
);

-- insering subject code and book_call_no into bd_subject 

INSERT INTO bd_subject VALUES (
    (
        SELECT
            subject_code
        FROM
            subject
        WHERE
            subject_details = 'Database Design'
    ),
    '005.74 C822D 2018'
);

-- insering subject code and book_call_no into bd_subject 

INSERT INTO bd_subject VALUES (
    (
        SELECT
            subject_code
        FROM
            subject
        WHERE
            subject_details = 'Database Management'
    ),
    '005.74 C822D 2018'
);
-- inserting book_call_no and author_id into bd_author

INSERT INTO bd_author VALUES (
    '005.74 C822D 2018',
    1
);

INSERT INTO bd_author VALUES (
    '005.74 C822D 2018',
    2
);

-- inserts  into book_copy 

INSERT INTO book_copy VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    ),
    100000,
    120,
    'N',
    '005.74 C822D 2018'
);

INSERT INTO book_copy VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888882'
    ),
    100000,
    120,
    'N',
    '005.74 C822D 2018'
);

INSERT INTO book_copy VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    100000,
    120,
    'N',
    '005.74 C822D 2018'
);

-- update branch to increment the branch_count_books according to the number of book copies added for each branch

UPDATE branch
SET
    branch_count_books = (
        SELECT
            branch_count_books
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    ) + 1
WHERE
    branch_code = (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    );

UPDATE branch
SET
    branch_count_books = (
        SELECT
            branch_count_books
        FROM
            branch
        WHERE
            branch_contact_no = '8888888882'
    ) + 1
WHERE
    branch_code = (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888882'
    );

UPDATE branch
SET
    branch_count_books = (
        SELECT
            branch_count_books
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ) + 1
WHERE
    branch_code = (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    );
    
--one commit statement to show its one transaction

COMMIT;



/*
2.2
An Oracle sequence is to be implemented in the database for the subsequent insertion of records into the database for  
BORROWER table. 

Provide the CREATE 	SEQUENCE statement to create a sequence which could be used to provide primary key values for the BORROWER 
table. The sequence should start at 10 and increment by 1.
*/
-- creating sequence for borrower_no

CREATE SEQUENCE borrower_bor_no_seq START WITH 10 INCREMENT BY 1 NOCACHE;

/*
2.3
Provide the DROP SEQUENCE statement for the sequence object you have created in question 2.2 above. 
*/
-- statement to drop borrower sequence 

DROP SEQUENCE borrower_bor_no_seq;

--Q3
/*
--3.1
Today is 20th September, 2018, add a new borrower in the database. Some of the details of the new borrower are:
		Name: Ada LOVELACE
		Home Branch: Clayton (Ph: 8888888881)
You may make up any other reasonable data values you need to be able to add this borrower.
*/

-- insert Ada Lovelace into borrower

INSERT INTO borrower VALUES (
    borrower_bor_no_seq.NEXTVAL,
    'Ada',
    'Lovelace',
    'Wellington',
    'Clayton',
    '3800',
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    )
);
--commit satement to complete a transaction

COMMIT;

/*
--3.2
Immediately after becoming a member, at 4PM, Ada places a reservation on a book at the Mulgrave branch (Ph: 8888888883). Some 
of the details of the book that Ada  has placed a reservation on are:

		Call Number: 005.74 C822D 2018
        Title: Database Systems: Design, Implementation, and Management
		Publication Year: 2018
		Edition: 13

You may assume:
MonLib has not purchased any further copies of this book, beyond those which you inserted in Task 2.1
that nobody has become a member of the library between Ada becoming a member and this reservation.
*/

--  insert into reserve for book_call_no=005.74 C822D 2018 in Mulgrave branch

INSERT INTO reserve VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    (
        SELECT
            bc_id
        FROM
            book_copy
        WHERE
            book_call_no = '005.74 C822D 2018'
            AND branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
    ),
    TO_DATE('20/09/2018 16:00:00','dd/mm/yyyy hh24:mi:ss'),
    borrower_bor_no_seq.CURRVAL
);

COMMIT;
/*
3.3
After 7 days from reserving the book, Ada receives a notification from the Mulgrave library that the book she had placed
reservation on is available. Ada is very excited about the book being available as she wants to do very well in FIT2094 unit 
that she is currently studying at Monash University. Ada goes to the library and borrows the book at 2 PM on the same day of 
receiving the notification.

You may assume that there is no other borrower named Ada Lovelace.
*/

-- insert into loan for Mulgrave branch and book_call_no 005.74 C822D 2018

INSERT INTO loan VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    (
        SELECT
            bc_id
        FROM
            book_copy
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
    ),
    (
        SELECT
            reserve_date_time_placed + 7 - ( 2 / 24 )
        FROM
            reserve
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
            AND bor_no = (
                SELECT
                    bor_no
                FROM
                    borrower
                WHERE
                    bor_fname = 'Ada'
                    AND bor_lname = 'Lovelace'
            )
    ),
    (
        SELECT
            reserve_date_time_placed + 7 + 28 - ( 2 / 24 )
        FROM
            reserve
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
            AND bor_no = (
                SELECT
                    bor_no
                FROM
                    borrower
                WHERE
                    bor_fname = 'Ada'
                    AND bor_lname = 'Lovelace'
            )
    ),
    NULL,
    (
        SELECT
            bor_no
        FROM
            borrower
        WHERE
            bor_fname = 'Ada'
            AND bor_lname = 'Lovelace'
    )
);
-- as the book is now loaned - remove the record for that book to be reserved from reserve
DELETE FROM reserve
WHERE
    bor_no = (
        SELECT
            bor_no
        FROM
            borrower
        WHERE
            bor_fname = 'Ada'
            AND bor_lname = 'Lovelace'
    )
    AND branch_code = (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    )
    AND bc_id = (
        SELECT
            bc_id
        FROM
            book_copy
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND book_call_no = '005.74 C822D 2018'
    );

COMMIT;

/*
3.4
At 2 PM on the day the book is due, Ada goes to the library and renews the book as her exam for FIT2094 is in 2 weeks.
		
You may assume that there is no other borrower named Ada Lovelace.
*/

--update statement to 

UPDATE loan
SET
    loan_actual_return_date = loan_due_date 
WHERE
    branch_code = (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    )
    AND bc_id = (
        SELECT
            bc_id
        FROM
            book_copy
        WHERE
            book_call_no = '005.74 C822D 2018'
            AND branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
    )
    AND loan_date_time = (
        SELECT
            loan_date_time
        FROM
            loan
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
            AND loan_actual_return_date IS NULL
    );


--insert new record into loan for the renewed book
INSERT INTO loan VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    (
        SELECT
            bc_id
        FROM
            book_copy
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND book_call_no = '005.74 C822D 2018'
    ),
    (
        SELECT
            loan_actual_return_date
        FROM
            loan
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
            AND loan_date_time = TO_DATE('20/09/2018 16:00:00','dd/mm/yyyy hh24:mi:ss'
            ) + 7 - ( 2 / 24 )
    ),
    (
        SELECT
            loan_actual_return_date + 28
        FROM
            loan
        WHERE
            branch_code = (
                SELECT
                    branch_code
                FROM
                    branch
                WHERE
                    branch_contact_no = '8888888883'
            )
            AND bc_id = (
                SELECT
                    bc_id
                FROM
                    book_copy
                WHERE
                    branch_code = (
                        SELECT
                            branch_code
                        FROM
                            branch
                        WHERE
                            branch_contact_no = '8888888883'
                    )
                    AND book_call_no = '005.74 C822D 2018'
            )
            AND loan_date_time = TO_DATE('20/09/2018 16:00:00','dd/mm/yyyy hh24:mi:ss'
            ) + 7 - ( 2 / 24 )
    ),
    NULL,
    (
        SELECT
            bor_no
        FROM
            borrower
        WHERE
            bor_fname = 'Ada'
            AND bor_lname = 'Lovelace'
    )
);
-- to complete the renew transcation
COMMIT;
    
--Q4
/*
4.1
Record whether a book is damaged (D) or lost (L). If the book is not damaged or lost,then it  is good (G) which means, 
it can be loaned. The value cannot be left empty  for this. Change the "live" database and add this required information 
for all the  books currently in the database. You may assume that condition of all existing books will be recorded as being 
good. The information can be updated later, if need be. 
*/

-- alter table to add column that specify the book state

ALTER TABLE book_copy ADD book_state CHAR(1);

-- adding comment to the column

COMMENT ON COLUMN book_copy.book_state IS
    'state of book- damaged(D), lost(L) or good(D)';

-- altering the structure of the table 
-- adding a check constraint 

ALTER TABLE book_copy
    ADD CONSTRAINT bc_state_chk CHECK ( book_state IN (
        'D',
        'L',
        'G'
    ) );

-- update the book_state for all currently exsisting books to 'G'

UPDATE book_copy
SET
    book_state = 'G';
-- commit to complete the update transaction

COMMIT;

--Alter table to set the book_state as a mandatory field

ALTER TABLE book_copy MODIFY
    book_state CHAR(1) NOT NULL;

/*
4.2
Allow borrowers to be able to return the books they have loaned to any library branch as MonLib is getting a number of requests 
regarding this from borrowers. As part of this process MonLib wishes to record which branch a particular loan is returned to. 
Change the "live" database and add this required information for all the loans  currently in the database. For all completed 
loans, to this time, books were returned at the same branch from where those were loaned.
*/

-- add a column for which branch the loaned book copy will be returned to 

ALTER TABLE loan ADD bc_returned_to NUMERIC(2);

-- adding comments to the column 

COMMENT ON COLUMN loan.bc_returned_to IS
    'Branch code where book is returned';

-- adding foreign key for branch_returned_to

ALTER TABLE loan
    ADD CONSTRAINT loan_return_branch_fk FOREIGN KEY ( bc_returned_to )
        REFERENCES branch ( branch_code );

-- update statemnet for completed loans where the book copy has been returned to same branch it was borrowed from

UPDATE loan
SET
    bc_returned_to = branch_code
WHERE
    loan_actual_return_date IS NOT NULL;
    
--commit to complete the update transaction.    

COMMIT;



/*
4.3
Some of the MonLib branches have become very large and it is difficult for a single manager to look after all aspects of the 
branch. For this reason MonLib are intending to appoint two managers for the larger branches starting in the new year - one 
manager for the Fiction collection and another for the Non-Fiction collection. The branches which continue to have one manager 
will ask this manager to manage the branches Full collection. The number of branches which will require two managers is quite 
small (around 10% of the total MonLib branches). Change the "live" database to allow monLib the option of appointing two 
managers to a branch and track and also record, for all managers, which collection/s they are managing. 

In the new year, since the Mulgrave branch (Ph: 8888888883) has a huge collection of books in comparison to the Clayton and 
Oakleigh branches, Robert (Manager id: 1) who is currently managing the Clayton branch (Ph: 8888888881) has been asked to 
manage the Fiction collection of the Mulgrave branch, as well as the full collection at the Clayton branch. Thabie 
(Manager id: 2) who is currently managing the Oakleigh branch (Ph: 8888888882) has been asked to manage the Non-Fiction 
collection of Mulgrave branch, as well as the full collection at the Oakleigh branch. Write the code to implement these 
changes.
*/

--create a table for manager type

CREATE TABLE manager_type (
    branch_code       NUMERIC(2) NOT NULL,
    man_id            NUMERIC(2) NOT NULL,
    collection_type   CHAR(2) NOT NULL
);
--adding comments to the fields

COMMENT ON COLUMN manager_type.branch_code IS
    'Branch number ';

COMMENT ON COLUMN manager_type.man_id IS
    'Manager id ';

COMMENT ON COLUMN manager_type.collection_type IS
    'type of collection manager manages - F (Fiction),NF(Non-Fiction), FC(Full collection)'
    ;

--dropping the man_id column from branch

ALTER TABLE branch DROP COLUMN man_id;
--altering the structure of manager type

--adding primary foreign keys

ALTER TABLE manager_type ADD CONSTRAINT manager_type_pk PRIMARY KEY ( branch_code

,
                                                                      man_id );

ALTER TABLE manager_type
    ADD CONSTRAINT manager_type_branch_fk FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE manager_type
    ADD CONSTRAINT manager_type_manager_fk FOREIGN KEY ( man_id )
        REFERENCES manager ( man_id );

-- adding check constraint for the collection type

ALTER TABLE manager_type
    ADD CONSTRAINT collection_type_chk CHECK ( collection_type IN (
        'F',
        'NF',
        'FC'
    ) );
    
--inserts for manager_type 
--inserting manager id =1 to Clayton branch and manages the full collection

INSERT INTO manager_type VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    ),
    1,
    'FC'
);
--inserting manager id =1 to Mulgrave branch and manages the Fiction collection

INSERT INTO manager_type VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    1,
    'F'
);
-- to complete the transaction for manager (id =1)

COMMIT;
--inserting manager id =2 to Oakleigh branch and manages the full collection

INSERT INTO manager_type VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888882'
    ),
    2,
    'FC'
);

--inserting manager id =2 to Mulgrave branch and manages the non-fiction collection

INSERT INTO manager_type VALUES (
    (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
    2,
    'NF'
);
-- commit to complete the transaction for manager(id=2)

COMMIT;
--==========================================================================
SET ECHO OFF