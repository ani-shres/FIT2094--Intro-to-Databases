-- Start of MonLib Schema


-- Generated by Oracle SQL Developer Data Modeler 18.2.0.179.0806
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g

CREATE TABLE author (
    author_id      NUMBER(4) NOT NULL,
    author_fname   VARCHAR2(50) NOT NULL,
    author_lname   VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN author.author_id IS
    'Author identifier';

COMMENT ON COLUMN author.author_fname IS
    'Author first name';

COMMENT ON COLUMN author.author_lname IS
    'Author last name';

ALTER TABLE author ADD CONSTRAINT author_pk PRIMARY KEY ( author_id );

CREATE TABLE bd_author (
    book_call_no   VARCHAR2(20) NOT NULL,
    author_id      NUMBER(4) NOT NULL
);

COMMENT ON COLUMN bd_author.book_call_no IS
    'Titles call number - identifies a title';

COMMENT ON COLUMN bd_author.author_id IS
    'Author identifier';

ALTER TABLE bd_author ADD CONSTRAINT bd_author_pk PRIMARY KEY ( author_id,
                                                                book_call_no );

CREATE TABLE bd_subject (
    subject_code   NUMBER(4) NOT NULL,
    book_call_no   VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN bd_subject.subject_code IS
    'Subject Identifier';

COMMENT ON COLUMN bd_subject.book_call_no IS
    'Titles call number - identifies a title';

ALTER TABLE bd_subject ADD CONSTRAINT bd_subject_pk PRIMARY KEY ( subject_code,
                                                                  book_call_no );



CREATE TABLE book_detail (
    book_call_no          VARCHAR2(20) NOT NULL,
    book_title            VARCHAR2(100) NOT NULL,
    book_classification   CHAR(1) NOT NULL,
    book_no_pages         NUMBER(4) NOT NULL,
    book_pub_year         DATE NOT NULL,
    book_edition          VARCHAR2(3),
    pub_id                NUMBER(4) NOT NULL
);

ALTER TABLE book_detail
    ADD CONSTRAINT bk_classif_chk CHECK ( book_classification IN (
        'F',
        'R'
    ) );

COMMENT ON COLUMN book_detail.book_call_no IS
    'Titles call number - identifies a title';

COMMENT ON COLUMN book_detail.book_title IS
    'Title of book';

COMMENT ON COLUMN book_detail.book_classification IS
    'Title classification - (R)eference or (F)iction';

COMMENT ON COLUMN book_detail.book_no_pages IS
    'No of pages in the title';

COMMENT ON COLUMN book_detail.book_pub_year IS
    'Publication year of title';

COMMENT ON COLUMN book_detail.book_edition IS
    'Book Edition';

COMMENT ON COLUMN book_detail.pub_id IS
    'Library assigned publisher identifier';

ALTER TABLE book_detail ADD CONSTRAINT book_detail_pk PRIMARY KEY ( book_call_no );

CREATE TABLE borrower (
    bor_no         NUMBER(6) NOT NULL,
    bor_fname      VARCHAR2(59) NOT NULL,
    bor_lname      VARCHAR2(50) NOT NULL,
    bor_street     VARCHAR2(80) NOT NULL,
    bor_suburb     VARCHAR2(50) NOT NULL,
    bor_postcode   CHAR(4) NOT NULL,
    branch_code    NUMBER(2) NOT NULL
);

COMMENT ON COLUMN borrower.bor_no IS
    'Borrower identifier';

COMMENT ON COLUMN borrower.bor_fname IS
    'Borrowers first name';

COMMENT ON COLUMN borrower.bor_lname IS
    'Borrowers last name';

COMMENT ON COLUMN borrower.bor_street IS
    'Borrowers stree address';

COMMENT ON COLUMN borrower.bor_suburb IS
    'Borrowers Suburb';

COMMENT ON COLUMN borrower.bor_postcode IS
    'Borrowers postcode';

COMMENT ON COLUMN borrower.branch_code IS
    'Branch number ';

ALTER TABLE borrower ADD CONSTRAINT borrower_pk PRIMARY KEY ( bor_no );

CREATE TABLE branch (
    branch_code          NUMBER(2) NOT NULL,
    branch_name          VARCHAR2(50) NOT NULL,
    branch_address       VARCHAR2(100) NOT NULL,
    branch_contact_no    CHAR(10) NOT NULL,
    branch_count_books   NUMBER(5) NOT NULL,
    man_id               NUMBER(2) NOT NULL
);

COMMENT ON COLUMN branch.branch_code IS
    'Branch number ';

COMMENT ON COLUMN branch.branch_name IS
    'Name of Branch';

COMMENT ON COLUMN branch.branch_address IS
    'Address of Branch';

COMMENT ON COLUMN branch.branch_contact_no IS
    'Branch Phone Number';

COMMENT ON COLUMN branch.branch_count_books IS
    'Count of book copies held by the branch';

COMMENT ON COLUMN branch.man_id IS
    'Managers assigned identifier';

ALTER TABLE branch ADD CONSTRAINT branch_pk PRIMARY KEY ( branch_code );

ALTER TABLE branch ADD CONSTRAINT branch_contact_no_uq UNIQUE ( branch_contact_no );

CREATE TABLE manager (
    man_id           NUMBER(2) NOT NULL,
    man_fname        VARCHAR2(50) NOT NULL,
    man_lname        VARCHAR2(50) NOT NULL,
    man_contact_no   CHAR(10) NOT NULL
);

COMMENT ON COLUMN manager.man_id IS
    'Managers assigned identifier';

COMMENT ON COLUMN manager.man_fname IS
    'Managers first name';

COMMENT ON COLUMN manager.man_lname IS
    'Managers Last name';

COMMENT ON COLUMN manager.man_contact_no IS
    'Managers contact number';

ALTER TABLE manager ADD CONSTRAINT manager_pk PRIMARY KEY ( man_id );

CREATE TABLE publisher (
    pub_id        NUMBER(4) NOT NULL,
    pub_name      VARCHAR2(50) NOT NULL,
    pub_city      VARCHAR2(50) NOT NULL,
    pub_state     VARCHAR2(50) NOT NULL,
    pub_country   VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN publisher.pub_id IS
    'Library assigned publisher identifier';

COMMENT ON COLUMN publisher.pub_name IS
    'Publishers name';

COMMENT ON COLUMN publisher.pub_city IS
    'Publishers City';

COMMENT ON COLUMN publisher.pub_state IS
    'Publsihers state';

COMMENT ON COLUMN publisher.pub_country IS
    'Publishers Country';

ALTER TABLE publisher ADD CONSTRAINT publisher_pk PRIMARY KEY ( pub_id );

ALTER TABLE publisher ADD CONSTRAINT pub_name_uq UNIQUE ( pub_name );

CREATE TABLE subject (
    subject_code      NUMBER(4) NOT NULL,
    subject_details   VARCHAR2(80) NOT NULL
);

COMMENT ON COLUMN subject.subject_code IS
    'Subject Identifier';

COMMENT ON COLUMN subject.subject_details IS
    'Subject description';

ALTER TABLE subject ADD CONSTRAINT subject_pk PRIMARY KEY ( subject_code );

ALTER TABLE subject ADD CONSTRAINT  subject_details_uq UNIQUE ( subject_details );

ALTER TABLE bd_author
    ADD CONSTRAINT author_ta FOREIGN KEY ( author_id )
        REFERENCES author ( author_id );

ALTER TABLE bd_author
    ADD CONSTRAINT bd_ta FOREIGN KEY ( book_call_no )
        REFERENCES book_detail ( book_call_no );

ALTER TABLE bd_subject
    ADD CONSTRAINT bd_ts FOREIGN KEY ( book_call_no )
        REFERENCES book_detail ( book_call_no );

ALTER TABLE borrower
    ADD CONSTRAINT branch_borr FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE branch
    ADD CONSTRAINT manager_branch FOREIGN KEY ( man_id )
        REFERENCES manager ( man_id );

ALTER TABLE book_detail
    ADD CONSTRAINT publisher_bd FOREIGN KEY ( pub_id )
        REFERENCES publisher ( pub_id );

ALTER TABLE bd_subject
    ADD CONSTRAINT subject_ts FOREIGN KEY ( subject_code )
        REFERENCES subject ( subject_code );

-- End of MonLib Schema