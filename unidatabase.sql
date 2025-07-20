

CREATE TABLE fakulteti (
    fakultetid   NUMBER NOT NULL,
    fullname     VARCHAR2(100) NOT NULL,
    shortname    VARCHAR2(20)
) TABLESPACE USERS;

ALTER TABLE fakulteti ADD CONSTRAINT fakulteti_pk PRIMARY KEY (fakultetid)
USING INDEX TABLESPACE USERS;

CREATE TABLE grupi (
    groupid   NUMBER NOT NULL,
    name      VARCHAR2(10) NOT NULL,
    specid    NUMBER NOT NULL,
    kurs      NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE grupi ADD CONSTRAINT grupi_pk PRIMARY KEY (groupid)
USING INDEX TABLESPACE USERS;
ALTER TABLE grupi ADD education_type_id NUMBER;




CREATE TABLE izpiti (
    izpitid     NUMBER NOT NULL,
    subjectid   NUMBER NOT NULL,
    groupid     NUMBER NOT NULL,
    "Date"      DATE NOT NULL,
    type        VARCHAR2(10)
) TABLESPACE USERS;

ALTER TABLE izpiti ADD CONSTRAINT izpiti_pk PRIMARY KEY (izpitid)
USING INDEX TABLESPACE USERS;

CREATE TABLE katedri (
    katedraid    NUMBER NOT NULL,
    name         VARCHAR2(50) NOT NULL,
    fakultetid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE katedri ADD CONSTRAINT katedri_pk PRIMARY KEY (katedraid)
USING INDEX TABLESPACE USERS;

CREATE TABLE lecturers (
    lecturerid    NUMBER NOT NULL,
    titla         VARCHAR2(20) NOT NULL,
    firstname     VARCHAR2(30) NOT NULL,
    lastname      VARCHAR2(30) NOT NULL,
    lecturernom   VARCHAR2(5) NOT NULL,
    katedraid     NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE lecturers
    ADD CONSTRAINT chk_lecturernom_format CHECK (REGEXP_LIKE(lecturernom, '^10[0-9]{3}$'));

ALTER TABLE lecturers ADD CONSTRAINT lecturers_pk PRIMARY KEY (lecturerid)
USING INDEX TABLESPACE USERS;

CREATE TABLE ocenki (
    gradeid      NUMBER NOT NULL,
    studentid    NUMBER NOT NULL,
    subjectid    NUMBER NOT NULL,
    lecturerid   NUMBER NOT NULL,
    grade        NUMBER NOT NULL,
    "Date"       DATE NOT NULL
) TABLESPACE USERS;

ALTER TABLE ocenki
    ADD CONSTRAINT chk_grade_range CHECK (grade BETWEEN 1 AND 6);

ALTER TABLE ocenki ADD CONSTRAINT ocenki_pk PRIMARY KEY (gradeid)
USING INDEX TABLESPACE USERS;

CREATE TABLE predmeti (
    subjectid   NUMBER NOT NULL,
    name        VARCHAR2(100) NOT NULL,
    semestur    NUMBER NOT NULL,
    specid      NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE predmeti ADD CONSTRAINT predmeti_pk PRIMARY KEY (subjectid)
USING INDEX TABLESPACE USERS;

CREATE TABLE programi (
    programid    NUMBER NOT NULL,
    groupid      NUMBER NOT NULL,
    subjectid    NUMBER NOT NULL,
    day          VARCHAR2(10) NOT NULL,
    hour         VARCHAR2(10) NOT NULL,
    lecturerid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE programi ADD CONSTRAINT programi_pk PRIMARY KEY (programid)
USING INDEX TABLESPACE USERS;

CREATE TABLE specialnosti (
    specid       NUMBER NOT NULL,
    name         VARCHAR2(100) NOT NULL,
    shortname    VARCHAR2(10) NOT NULL,
    fakultetid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE specialnosti ADD CONSTRAINT specialnosti_pk PRIMARY KEY (specid)
USING INDEX TABLESPACE USERS;

CREATE TABLE students (
    studentid           NUMBER NOT NULL,
    firstname           VARCHAR2(30) NOT NULL,
    lastname            VARCHAR2(30) NOT NULL,
    facnom              VARCHAR2(8) NOT NULL,
    form_na_obuchenie   VARCHAR2(20) NOT NULL,
    oks                 VARCHAR2(20) NOT NULL,
    priem               NUMBER NOT NULL,
    fakultetid          NUMBER NOT NULL,
    specid              NUMBER NOT NULL,
    groupid             NUMBER NOT NULL,
    semesturcount       NUMBER NOT NULL,
    kurs                NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE students ADD CONSTRAINT students_pk PRIMARY KEY (studentid)
USING INDEX TABLESPACE USERS;

CREATE TABLE users (
    userid      INTEGER NOT NULL,
    username    VARCHAR2(50) NOT NULL,
    password    VARCHAR2(100) NOT NULL,
    role        VARCHAR2(20) NOT NULL,
    relatedid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE users ADD CONSTRAINT users_pk PRIMARY KEY (userid)
USING INDEX TABLESPACE USERS;

ALTER TABLE users ADD CONSTRAINT users__un UNIQUE (username) USING INDEX TABLESPACE USERS;

CREATE TABLE education_types (
    education_type_id NUMBER PRIMARY KEY,
    education_type_name VARCHAR2(50) NOT NULL 
)TABLESPACE USERS;



ALTER TABLE grupi
    ADD CONSTRAINT grupi_specialnosti_fk FOREIGN KEY (specid)
        REFERENCES specialnosti (specid);
ALTER TABLE grupi
ADD CONSTRAINT fk_grupi_education_type FOREIGN KEY (education_type_id)
REFERENCES education_types(education_type_id);


ALTER TABLE izpiti
    ADD CONSTRAINT izpiti_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE izpiti
    ADD CONSTRAINT izpiti_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE katedri
    ADD CONSTRAINT katedri_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE lecturers
    ADD CONSTRAINT lecturers_katedri_fk FOREIGN KEY (katedraid)
        REFERENCES katedri (katedraid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_lecturers_fk FOREIGN KEY (lecturerid)
        REFERENCES lecturers (lecturerid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_students_fk FOREIGN KEY (studentid)
        REFERENCES students (studentid);



ALTER TABLE programi
    ADD CONSTRAINT programi_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE programi
    ADD CONSTRAINT programi_lecturers_fk FOREIGN KEY (lecturerid)
        REFERENCES lecturers (lecturerid);

ALTER TABLE programi
    ADD CONSTRAINT programi_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE specialnosti
    ADD CONSTRAINT specialnosti_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE students
    ADD CONSTRAINT students_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE students
    ADD CONSTRAINT students_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE students
    ADD CONSTRAINT students_specialnosti_fk FOREIGN KEY (specid)
        REFERENCES specialnosti (specid);

ALTER TABLE users
    ADD CONSTRAINT users_lecturers_fk FOREIGN KEY (relatedid)
        REFERENCES lecturers (lecturerid);
        
ALTER TABLE students
ADD education_type_id NUMBER;

ALTER TABLE students
ADD CONSTRAINT fk_education_type
FOREIGN KEY (education_type_id)
REFERENCES education_types(education_type_id);





INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (1, 'Faculty of Mechanical Engineering and Technology', 'MFT');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (2, 'English-Taught Education', 'ETE');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (3, 'Shipbuilding Faculty', 'KF');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (4, 'Faculty of Electrical Engineering', 'EF');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (6, 'Faculty of Computer Science and Automation', 'FITA');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (7, 'Dobrudzha Technological College', 'DTK');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (9, 'College within TU - Varna', 'KTU');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (10, 'Department of Language and Continuing Education and Sport', 'DEPOS');


-- ??? (fakultetid = 1)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (11, 'Technology of Machine Building and Metal Cutting Machines', 'TMMM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (12, 'Materials Science and Technology of Materials', 'MTM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (14, 'General University Workshop', 'GUW', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (21, 'Transport Technology and Equipment', 'TTT', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (23, 'Mechanics and Machine Elements', 'MME', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (31, 'Industrial Management', 'IM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (82, 'Plant Growing', 'P', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (83, 'Automotive Engineering', 'AE', 1);

-- ?? (fakultetid = 3)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (13, 'Industrial Design', 'ID', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (26, 'Thermal Engineering', 'T', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (34, 'Shipbuilding, Ship Machines and Mechanisms', 'KKMM', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (35, 'Navigation, Transport Management and Waterway Protection', 'KUTOCHVP', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (81, 'Ecology and Environmental Protection', 'EOOS', 3);

-- ?? (fakultetid = 4)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (41, 'Power Supply and Electrical Equipment', 'ESEO', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (42, 'Power Engineering', 'EE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (43, 'Electrical Engineering and Electrical Technologies', 'ETET', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (44, 'Theoretical and Measurement Electrical Engineering', 'TIE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (45, 'Mathematics and Physics', 'MF', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (91, 'Social and Legal Sciences', 'SPN', 4);

-- ???? (fakultetid = 6)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (54, 'Communication Technology and Technologies', 'KTT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (55, 'Electronic Technology and Microelectronics', 'ETM', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (61, 'Production Automation', 'AP', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (64, 'Computer Science and Technologies', 'KHT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (65, 'Software and Internet Technologies', 'SIT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (66, 'Automation, Information and Control Computer Systems', 'AICCS', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (67, 'Automation, Robotics and Control Computer Systems', 'ARUKS', 6);


-- ??? (fakultetid = 7)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (75, 'Dobrudzha Technological College', 'DTK', 7);

-- ??? (fakultetid = 9)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (92, 'College within TU - Varna', 'KTU', 9);

-- ????? (fakultetid = 10)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (37, 'Physical Education and Sport', 'FVS', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (53, 'Section "Language Training and Continuing Qualification"', 'EOPK', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (62, 'Section "Mathematics"', 'Math', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (63, 'Physics', 'Physics', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (98, 'Department of Language and Continuing Education and Sport', 'DEPOS', 10);

INSERT INTO education_types (education_type_id, education_type_name) VALUES (1, 'Full-time');
INSERT INTO education_types (education_type_id, education_type_name) VALUES (2, 'Part-time');


DECLARE
    v_groupid NUMBER := 1;
    v_podgrupa VARCHAR2(1);
    v_education_type VARCHAR2(10);
    v_education_type_id NUMBER;
BEGIN
    FOR et IN (
        SELECT 1 as id, 'Full-time' as txt FROM dual 
        UNION ALL 
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        v_education_type_id := et.id;
        v_education_type := et.txt;

        FOR rec IN (
            SELECT specid, shortname FROM (
                SELECT 11 specid, 'TMMM' shortname FROM dual UNION ALL
                SELECT 12, 'MTM' FROM dual UNION ALL
                SELECT 14, 'GUW' FROM dual UNION ALL
                SELECT 21, 'TTT' FROM dual UNION ALL
                SELECT 23, 'MME' FROM dual UNION ALL
                SELECT 31, 'IM' FROM dual UNION ALL
                SELECT 82, 'P' FROM dual UNION ALL
                SELECT 13, 'ID' FROM dual UNION ALL
                SELECT 26, 'T' FROM dual UNION ALL
                SELECT 34, 'KKMM' FROM dual UNION ALL
                SELECT 35, 'KUTOCHVP' FROM dual UNION ALL
                SELECT 81, 'EOOS' FROM dual UNION ALL
                SELECT 41, 'ESEO' FROM dual UNION ALL
                SELECT 42, 'EE' FROM dual UNION ALL
                SELECT 43, 'ETET' FROM dual UNION ALL
                SELECT 44, 'TIE' FROM dual UNION ALL
                SELECT 45, 'MF' FROM dual UNION ALL
                SELECT 91, 'SPN' FROM dual UNION ALL
                SELECT 54, 'KTT' FROM dual UNION ALL
                SELECT 55, 'ETM' FROM dual UNION ALL
                SELECT 61, 'AP' FROM dual UNION ALL
                SELECT 64, 'KHT' FROM dual UNION ALL
                SELECT 65, 'SIT' FROM dual UNION ALL
                SELECT 75, 'DTK' FROM dual UNION ALL
                SELECT 92, 'KTU' FROM dual UNION ALL
                SELECT 37, 'FVS' FROM dual UNION ALL
                SELECT 53, 'EOPK' FROM dual UNION ALL
                SELECT 63, 'Physics' FROM dual UNION ALL
                SELECT 98, 'DEPOS' FROM dual UNION ALL
                SELECT 62, 'Math' FROM dual
            )
        )
        LOOP
            FOR kurs IN 1..4 LOOP
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    FOR groupnum IN 1..5 LOOP
                        INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                        VALUES (
                            v_groupid,
                            rec.shortname || groupnum || v_podgrupa,
                            rec.specid,
                            kurs,
                            v_education_type,
                            v_education_type_id
                        );
                        v_groupid := v_groupid + 1;
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

DECLARE
    v_groupid NUMBER := 2401;  -- ???????? ????????? ?? 2401
    v_podgrupa VARCHAR2(1);
    v_group_name VARCHAR2(50);
BEGIN
    FOR et IN (
        SELECT 1 as education_type_id, 'Full-time' as education_type FROM dual
        UNION ALL
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        FOR rec IN (
            -- ??? ????? ??????? ? ??????????? ???????????? (specid, shortname)
            SELECT 11 specid, 'TMMM' shortname FROM dual UNION ALL
            SELECT 12, 'MTM' FROM dual
            -- ?????? ????? ??????????? ???????????? ???
        )
        LOOP
            FOR kurs IN 1..2 LOOP -- ???????? ??? 2 ?????
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    v_group_name := 'MG' || kurs || v_podgrupa || rec.shortname;

                    INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                    VALUES (
                        v_groupid,
                        v_group_name,
                        rec.specid,
                        kurs,
                        et.education_type,
                        et.education_type_id
                    );

                    v_groupid := v_groupid + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

ALTER TABLE grupi MODIFY (name VARCHAR2(20));


DECLARE
    v_groupid NUMBER := 2417;  -- ????????? ?? ????????? ???????? groupid
    v_podgrupa VARCHAR2(1);
    v_education_type VARCHAR2(10);
    v_education_type_id NUMBER;
    v_group_name VARCHAR2(20);
BEGIN
    FOR et IN (
        SELECT 1 as id, 'Full-time' as txt FROM dual 
        UNION ALL 
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        v_education_type_id := et.id;
        v_education_type := et.txt;

        FOR rec IN (
            SELECT specid, shortname FROM (
                SELECT 31 specid, 'IM' shortname FROM dual UNION ALL
                SELECT 13, 'ID' FROM dual UNION ALL
                SELECT 26, 'T' FROM dual UNION ALL
                SELECT 34, 'KKMM' FROM dual UNION ALL
                SELECT 35, 'KUTOCHVP' FROM dual UNION ALL
                SELECT 81, 'EOOS' FROM dual UNION ALL
                SELECT 41, 'ESEO' FROM dual UNION ALL
                SELECT 42, 'EE' FROM dual UNION ALL
                SELECT 43, 'ETET' FROM dual UNION ALL
                SELECT 44, 'TIE' FROM dual UNION ALL
                SELECT 91, 'SPN' FROM dual UNION ALL
                SELECT 54, 'KTT' FROM dual UNION ALL
                SELECT 55, 'ETM' FROM dual UNION ALL
                SELECT 61, 'AP' FROM dual UNION ALL
                SELECT 64, 'KHT' FROM dual UNION ALL
                SELECT 65, 'SIT' FROM dual
            )
        )
        LOOP
            FOR kurs IN 1..2 LOOP
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    v_group_name := 'MG' || kurs || v_podgrupa || rec.shortname;

                    INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                    VALUES (
                        v_groupid,
                        v_group_name,
                        rec.specid,
                        kurs,
                        v_education_type,
                        v_education_type_id
                    );

                    v_groupid := v_groupid + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/


SET SERVEROUTPUT ON;

SET SERVEROUTPUT ON;





DECLARE
    v_studentid NUMBER := 1;
    v_priem NUMBER; -- ?????? ?? ????? (23 ??? 24)
    v_fakultetid NUMBER;
    v_specid NUMBER;
    v_groupid NUMBER;
    v_oks VARCHAR2(20);
    v_oks_digit VARCHAR2(1);
    v_form_na_obuchenie VARCHAR2(20);
    v_form_digit VARCHAR2(1);
    v_education_type_id NUMBER;
    v_facnom VARCHAR2(8);
    v_semesturcount NUMBER;
    v_kurs NUMBER;
    v_fname VARCHAR2(30);
    v_lname VARCHAR2(30);
    v_counter NUMBER := 1; -- ???????? ?????
    v_fak_char VARCHAR2(1);

    v_groupname VARCHAR2(20);

    TYPE t_spec IS TABLE OF specialnosti%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE t_group IS TABLE OF grupi%ROWTYPE INDEX BY PLS_INTEGER;

    v_specs t_spec;
    v_groups t_group;
    v_spec_index NUMBER;
    v_group_index NUMBER;

    TYPE t_fakulteti IS TABLE OF NUMBER;
    v_fakulteti t_fakulteti := t_fakulteti(1, 2, 3, 4, 6, 7, 9, 10);

    v_fak_index NUMBER;
BEGIN
    -- ??????? ?????? ????????????
    SELECT * BULK COLLECT INTO v_specs FROM specialnosti;

    IF v_specs.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('???? ????????????!');
        RETURN;
    END IF;

    FOR i IN 1..100 LOOP
        -- ?????? ?? ????? 23 ??? 24 (????????)
        v_priem := CASE WHEN DBMS_RANDOM.VALUE < 0.5 THEN 23 ELSE 24 END;

        -- ????? ?? ???????? ?? ???????
        v_fak_index := TRUNC(DBMS_RANDOM.VALUE(1, v_fakulteti.COUNT + 1));
        v_fakultetid := v_fakulteti(v_fak_index);

        IF v_fakultetid = 10 THEN
            v_fak_char := '0';
        ELSE
            v_fak_char := TO_CHAR(v_fakultetid);
        END IF;

        -- ????? ?? ???????? ???????????
        v_spec_index := TRUNC(DBMS_RANDOM.VALUE(1, v_specs.COUNT + 1));
        v_specid := v_specs(v_spec_index).SPECID;

        -- ??????? ????? ??? ?????????????
        SELECT * BULK COLLECT INTO v_groups FROM grupi WHERE specid = v_specid;

        IF v_groups.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('??????????? ? ID ' || v_specid || ' ???? ?????, ??????????.');
            CONTINUE;
        END IF;

        -- ????? ?? ???????? ?????
        v_group_index := TRUNC(DBMS_RANDOM.VALUE(1, v_groups.COUNT + 1));
        v_groupid := v_groups(v_group_index).GROUPID;
        v_groupname := v_groups(v_group_index).NAME;
        v_kurs := v_groups(v_group_index).KURS;

        -- ?????????? ?? ??? ? ???? ????????
        IF MOD(i, 3) = 0 THEN
            v_oks := 'Bachelor';
            v_oks_digit := '2';
            v_semesturcount := 8;
        ELSE
            v_oks := 'Master';
            v_oks_digit := '5';
            v_semesturcount := 4;
        END IF;

        -- ?????????? ?? ????? ?? ???????? ? ??? ???????????
        IF MOD(i, 2) = 0 THEN
            v_form_na_obuchenie := 'Full-time';
            v_form_digit := '1';
            v_education_type_id := 1;
        ELSE
            v_form_na_obuchenie := 'Part-time';
            v_form_digit := '2';
            v_education_type_id := 2;
        END IF;

        v_fname := 'Student_' || i;
        v_lname := 'Test_' || i;

        -- ????????? facnom
        v_facnom := TO_CHAR(v_priem) || v_fak_char || v_oks_digit || v_form_digit || LPAD(TO_CHAR(v_counter), 3, '0');

        -- ???????? ? students ?????????
        INSERT INTO students (
            studentid, firstname, lastname, facnom,
            form_na_obuchenie, oks, priem, fakultetid,
            specid, groupid, semesturcount, kurs, education_type_id
        ) VALUES (
            v_studentid, v_fname, v_lname, v_facnom,
            v_form_na_obuchenie, v_oks, v_priem, v_fakultetid,
            v_specid, v_groupid, v_semesturcount, v_kurs, v_education_type_id
        );

        DBMS_OUTPUT.PUT_LINE(
            '?????? ??????? ' || v_studentid || ': ' || v_fname || ' ' || v_lname ||
            ', ?????????? ?????: ' || v_facnom ||
            ', ?????: ' || v_groupname
        );

        v_studentid := v_studentid + 1;
        v_counter := v_counter + 1;
        IF v_counter > 999 THEN
            v_counter := 1;
        END IF;
    END LOOP;
END;

ALTER TABLE katedri MODIFY (name VARCHAR2(100));

INSERT INTO katedri (katedraid, name, fakultetid) VALUES (1, 'Automation of Production', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (2, 'Electronics and Microelectronics', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (3, 'Computer Science and Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (4, 'Communication Technology and Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (5, 'Software and Internet Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (6, 'Materials Science and Technology of Materials', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (7, 'Mechanics and Machine Elements', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (8, 'Transport Technology and Techniques', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (9, 'Ecology and Environmental Protection', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (10, 'Industrial Design', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (11, 'Navigation, Transport Management and Waterway Cleanliness', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (12, 'Shipbuilding, Ship Machines and Mechanisms', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (13, 'Thermal Engineering', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (14, 'Power Supply and Electrical Equipment', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (15, 'Electrical Engineering and Electrotechnologies', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (16, 'Theoretical and Measurement Electrical Engineering', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (17, 'Social and Legal Sciences', 10);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (18, 'Department of Language and Continuing Education and Sport', 10);

--??????????, ????????????? ? ??????????? ?????????? ???????
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1, 'Mathematics - Part 1', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (2, 'Programming and Computer Use', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (3, 'Electrical Documentation', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (4, 'Economics', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (5, 'Foreign Language - Part 1', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (6, 'Practical Training', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (7, 'Sports - Part 1', 1, 66);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (8, 'Mathematics - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (9, 'Physics', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (10, 'Electronics', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (11, 'Theoretical Electrical Engineering', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (12, 'Foreign Language - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (13, 'Practical Training - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (14, 'Sports - Part 2', 2, 66);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (15, 'Electrical Engineering Materials', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (16, 'Electrical Measurements', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (17, 'Technical Mechanics', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (18, 'Electromechanical Devices', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (19, 'Introduction to MATLAB', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (20, 'Sensors in Automation and Robotics', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (21, 'Sports - Part 3', 3, 66);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (22, 'Control Theory - Part 1', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (23, 'Data and Signal Processing in Automation', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (24, 'Digital Circuitry', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (25, 'Logic Control Systems', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (26, 'Technical Safety', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (27, 'Sports - Part 4', 4, 66);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (28, 'Control Theory - Part 2', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (29, 'Digital Control Systems', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (30, 'Technical Means for Automation', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (31, 'Embedded Systems', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (32, 'Elective - Control Theory or Digital Control Systems', 5, 66);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (33, 'Programmable Controllers', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (34, 'System Identification', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (35, 'Electronic Actuators in Automation', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (36, 'Automated Electric Drives', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (37, 'Elective Project - Identification or Automated Drives', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (38, 'Specialized Internship', 6, 66);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (39, 'Control of Technological Processes', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (40, 'Control of Electromechanical Systems', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (41, 'System Modeling and Optimization', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (42, 'Elective - Industrial Information Systems or Control of Electric Drives', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (43, 'Industrial Communication Systems', 7, 66);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (44, 'Design of Automation Systems', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (45, 'Elective - CAD Systems or Automation of Renewable Energy Sources', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (46, 'Elective - Building Automation or Adaptive and Robust Control', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (47, 'Intelligent Control Systems', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (48, 'Comprehensive Project', 8, 66);


--??????????, ???????? ? ??????????? ?????????? ???????	
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (49, 'Mathematics - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (50, 'Physics', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (51, 'Computer Technologies', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (52, 'Technical Documentation', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (53, 'Foreign Language - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (54, 'Sports - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (55, 'Practical Training - Part 1', 1, 67);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (56, 'Mathematics - Part 2', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (57, 'Theoretical Electrical Engineering', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (58, 'Electrical Materials', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (59, 'Technical Mechanics', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (60, 'Economics', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (61, 'Foreign Language - Part 2', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (62, 'Sports - Part 2', 2, 67);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (63, 'Introduction to MATLABS', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (64, 'Electrical Measurements', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (65, 'Electronics - Part 1', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (66, 'Electromechanical Devices', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (67, 'Electronic Technological Devices', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (68, 'Sports - Part 3', 3, 67);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (69, 'Electronics - Part 2', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (70, 'Control Theory - Part 1', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (71, 'Data and Signal Processing in Automation', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (72, 'Automation Technical Means - Part 1', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (73, 'Logical Control Systems', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (74, 'Practical Training - Part 2', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (75, 'Sports - Part 4', 4, 67);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (76, 'Control Theory - Part 2', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (77, 'Digital Control Systems', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (78, 'Automation Technical Means - Part 2', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (79, 'Embedded Control Systems', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (80, 'Technical Safety', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (81, 'Elective Project - Control Theory or Digital Control Systems', 5, 67);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (82, 'System Identification', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (83, 'Programmable Controllers', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (84, 'Automated Electric Drives', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (85, 'Electronic Actuators in Automation', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (86, 'Industrial Communication Networks', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (87, 'Elective Project - System ID or Automated Electric Drives', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (88, 'Specialized Practice', 6, 67);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (89, 'Control of Technological Processes', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (90, 'Control of Electromechanical Systems', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (91, 'Elective - Modeling and Optimization or Industrial Automation Mechanisms or Robot Control Algorithms', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (92, 'Elective - Industrial Info Systems or Electrical Drive Control or Machine Vision', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (93, 'Elective - Building Automation or RES Automation or Robot Drives', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (94, 'Elective Project - Process Control or Robot Algorithms', 7, 67);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (95, 'Automation Systems Design', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (96, 'Elective - CAD Systems or Microcontroller Drives or Mobile Robots', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (97, 'Elective - Intelligent Systems or Adaptive and Robust Control or Industrial Robots', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (98, 'Comprehensive Project', 8, 67);

--??????????? ???????
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (99, 'Mathematics - Part 1', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (100, 'Transport Technology and Organization', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (101, 'Chemistry', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (102, 'Engine and Automobile Operation', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (103, 'English Language', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (104, 'Sports - Part 1', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (105, 'Practical Training - Part 1', 1, 83);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (106, 'Mathematics - Part 2', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (107, 'Materials Science and Technology', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (108, 'Information Technologies and Systems', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (109, 'Technical Documentation', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (110, 'Technical Mechanics', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (111, 'Sports - Part 2', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (112, 'Practical Training - Part 2', 2, 83);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (113, 'Strength of Materials', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (114, 'Interchangeability and Technical Measurements', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (115, 'Machine Elements', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (116, 'Fluid Mechanics', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (117, 'Transport Equipment Operational Materials', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (118, 'Sports - Part 3', 3, 83);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (119, 'Machine Elements - Project', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (120, 'Thermodynamics and Heat Transfer', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (121, 'Electrical Engineering and Electronics', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (122, 'Internal Combustion Engines Theory - Part 1', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (123, 'Transport Equipment Theory', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (124, 'Automated Design Systems in Transport Technology', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (125, 'Sports - Part 4', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (126, 'Specialized Practice', 4, 83);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (127, 'Electronic Systems in Transport Technology', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (128, 'Internal Combustion Engines Theory - Part 2', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (129, 'Mechanisms and Systems in Internal Combustion Engines', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (130, 'Combined and Alternative Engines', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (131, 'Traffic Safety', 5, 83);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (132, 'Automobile Design Technology', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (133, 'Automobile Design Technology - Project', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (134, 'Automobile Gas Systems', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (135, 'Economics', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (136, 'Internal Combustion Engines Testing', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (137, 'Fuel Systems and Gasoline Engine Control', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (138, 'Transport Equipment Operation', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (139, 'Specialized Practice', 6, 83);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (140, 'Transport Equipment Repair', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (141, 'Fuel Systems and Diesel Engine Control', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (142, 'Computer Technologies in Transport Technology', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (143, 'Oscillatory Processes in Automobile Technology', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (144, 'Transport Equipment Construction', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (145, 'Transport Equipment Construction - Project', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (146, 'Technical Safety', 7, 83);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (147, 'Torsional Vibrations in Automobile Technology', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (148, 'Torsional Vibrations in Automobile Technology - Project', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (149, 'Transport Technology Ecology', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (150, 'Computer Technologies in Automobile Technology', 8, 83);



