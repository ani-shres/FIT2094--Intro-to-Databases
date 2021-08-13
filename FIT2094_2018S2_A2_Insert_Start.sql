-- Sample data for MANAGER table.
INSERT INTO manager VALUES (
    1,
    'Robert',
    'Jones',
    '9999999991'
);

INSERT INTO manager VALUES (
    2,
    'Thabie',
    'Mansfield',
    '9999999992'
);

-- Sample data for BRANCH table.

INSERT INTO branch VALUES (
    10,
    'Clayton',
    '123 Jackson Street, Clayton, Victoria, 3168',
    '8888888881',
    5000,
    1
);

INSERT INTO branch VALUES (
    11,
    'Oakleigh',
    '321 Hume Street, Oakleigh, Victoria, 3166',
    '8888888882',
    4000,
    2
);

INSERT INTO branch VALUES (
    12,
    'Mulgrave',
    '45 Brisbane Street, Mulgrave, Victoria, 3170',
    '8888888883',
    45000,
    2
);

-- Sample data for PUBLISHER table.

INSERT INTO publisher VALUES (
    1,
    'Cengage',
    'Boston',
    'Massachusetts',
    'United States'
);

INSERT INTO publisher VALUES (
    2,
    'Pearson',
    'Boston',
    'Massachusetts',
    'United States'
);

INSERT INTO publisher VALUES (
    3,
    'Rodale',
    'Emmaus',
    'Pennsylvania',
    'United States'
);

-- Sample data for BOOK_DETAIL table.

INSERT INTO book_detail VALUES (
    '005.743 C752D 2015',
    'Database systems : a practical approach to design, implementation, and management',
    'R',
    1281,
    TO_DATE('2015','YYYY'),
    '6',
    2
);

INSERT INTO book_detail VALUES (
    '005.74 C822D 2017',
    'Database Systems: Design, Implementation, and Management',
    'R',
    791,
    TO_DATE('2017','YYYY'),
    '12',
    1
);

-- Sample data for SUBJECT table.

INSERT INTO subject VALUES (
    1,
    'Computer Programming'
);

INSERT INTO subject VALUES (
    2,
    'Database Design'
);

INSERT INTO subject VALUES (
    3,
    'Politics'
);

INSERT INTO subject VALUES (
    4,
    'Web Programming'
);

INSERT INTO subject VALUES (
    5,
    'Java'
);

INSERT INTO subject VALUES (
    6,
    'Python'
);

INSERT INTO subject VALUES (
    7,
    'Tennis'
);

INSERT INTO subject VALUES (
    8,
    'Human Computer Interaction'
);

INSERT INTO subject VALUES (
    9,
    'Database Management'
);

INSERT INTO subject VALUES (
    10,
    'Sports'
);

INSERT INTO subject VALUES (
    11,
    'Australian Football'
);

INSERT INTO subject VALUES (
    12,
    'Cricket'
);

INSERT INTO subject VALUES (
    13,
    'Soccer'
);

INSERT INTO subject VALUES (
    14,
    'Badminton'
);

-- Sample data for AUTHOR table.

INSERT INTO author VALUES (
    1,
    'Carlos',
    'Coronel'
);

INSERT INTO author VALUES (
    2,
    'Steven',
    'Morris'
);

INSERT INTO author VALUES (
    3,
    'Carolyn',
    'Begg'
);

INSERT INTO author VALUES (
    4,
    'Thomas',
    'Connolly'
);

                                                              
-- Sample data for BD_SUBJECT table.

INSERT INTO bd_subject VALUES (
    2,
    '005.743 C752D 2015'
);

INSERT INTO bd_subject VALUES (
    9,
    '005.743 C752D 2015'
);

INSERT INTO bd_subject VALUES (
    2,
    '005.74 C822D 2017'
);

INSERT INTO bd_subject VALUES (
    9,
    '005.74 C822D 2017'
);

-- Sample data for BD_AUTHOR table.

INSERT INTO bd_author VALUES (
    '005.743 C752D 2015',
    3
);

INSERT INTO bd_author VALUES (
    '005.743 C752D 2015',
    4
);

INSERT INTO bd_author VALUES (
    '005.74 C822D 2017',
    1
);

INSERT INTO bd_author VALUES (
    '005.74 C822D 2017',
    2
);

-- Sample data for BORROWER table.

INSERT INTO borrower VALUES (
    1,
    'Mark',
    'Zuckerberg',
    '1 Facebook Way',
    'Faceville',
    '1000',
    10
);

INSERT INTO borrower VALUES (
    2,
    'Sergey',
    'Brin',
    '2 Alphabet Way',
    'Alphaville',
    '2000',
    11
);

INSERT INTO borrower VALUES (
    3,
    'Larry',
    'Page',
    '1 Alphabet Way',
    'Alphaville',
    '2000',
    11
);

INSERT INTO borrower VALUES (
    4,
    'Bill',
    'Gates',
    '1 Microsoft Way',
    'Microville',
    '3000',
    12
);

COMMIT;