

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
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (102, 'Fleet and Port Operations', 'FPO', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (103, 'Electrical Equipment of Ships', 'EES', 3);


-- ?? (fakultetid = 4)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (41, 'Power Supply and Electrical Equipment', 'ESEO', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (42, 'Power Engineering', 'EE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (43, 'Electrical Engineering and Electrical Technologies', 'ETET', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (44, 'Theoretical and Measurement Electrical Engineering', 'TIE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (45, 'Mathematics and Physics', 'MF', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (91, 'Social and Legal Sciences', 'SPN', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (100, 'Biomedical Electronics', 'BME', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (101, 'Renewable Energy Sources', 'RES', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (56, 'Power Supply and Electrical Equipment', 'ESEO', 4);




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

--Automation, Information and Control Computer Systems
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


--Automation, Robotics and Control Computer Systems
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

--Automotive Engineering
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


--Agronomy
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (151, 'Mathematics - Part 1', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (152, 'Transport Technology and Organization', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (153, 'Chemistry', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (154, 'Engine and Vehicle Operation', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (155, 'English Language', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (156, 'Sports - Part 1', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (157, 'Practical Training - Part 1', 1, 82);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (158, 'Mathematics - Part 2', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (159, 'Materials Science and Technology', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (160, 'Information Technologies and Systems', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (161, 'Technical Documentation', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (162, 'Technical Mechanics', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (163, 'Sports - Part 2', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (164, 'Practical Training - Part 2', 2, 82);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (165, 'Strength of Materials', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (166, 'Interchangeability and Technical Measurements', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (167, 'Machine Elements', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (168, 'Fluid Mechanics', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (169, 'Operational Materials in Transport Technology', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (170, 'Sports - Part 3', 3, 82);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (171, 'Machine Elements - Project', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (172, 'Thermodynamics and Heat Transfer', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (173, 'Electrical Engineering and Electronics', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (174, 'Internal Combustion Engine Theory - Part 1', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (175, 'Transport Technology Theory', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (176, 'Automated Design Systems in Transport Technology', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (177, 'Sports - Part 4', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (178, 'Specialized Practice', 4, 82);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (179, 'Electronic Systems in Transport Technology', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (180, 'Internal Combustion Engine Theory - Part 2', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (181, 'Mechanisms and Systems in Internal Combustion Engines', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (182, 'Combined and Alternative Engines', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (183, 'Traffic Safety', 5, 82);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (184, 'Automotive Design Technology', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (185, 'Automotive Design Technology - Project', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (186, 'Automotive Gas Systems', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (187, 'Economics', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (188, 'Internal Combustion Engine Testing', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (189, 'Fuel Systems and Gasoline Engine Control', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (190, 'Transport Equipment Operation', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (191, 'Specialized Practice', 6, 82);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (192, 'Transport Equipment Repair', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (193, 'Fuel Systems and Diesel Engine Control', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (194, 'Computer Technologies in Transport Technology', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (195, 'Oscillatory Processes in Automotive Technology', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (196, 'Transport Equipment Construction', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (197, 'Transport Equipment Construction - Project', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (198, 'Technical Safety', 7, 82);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (199, 'Torsional Vibrations in Automotive Technology', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (200, 'Torsional Vibrations in Automotive Technology - Project', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (201, 'Ecology of Transport Technology', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (202, 'Computer Technologies in Automotive Technology', 8, 82);


--Biomedical Electronics
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (203, 'Mathematics – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (204, 'Programming and Computer Usage', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (205, 'Electrical Engineering Documentation', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (206, 'Standards in Electronics', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (207, 'Foreign Language – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (208, 'Practical Training – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (209, 'Specialized Sports Training – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (210, 'Sports and Social Adaptation – Part 1', 1, 100);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (211, 'Mathematics – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (212, 'Physics', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (213, 'Electronics', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (214, 'Theoretical Electrical Engineering', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (215, 'Foreign Language – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (216, 'Practical Training – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (217, 'Specialized Sports Training – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (218, 'Sports and Social Adaptation – Part 2', 2, 100);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (219, 'Electrical Engineering Materials', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (220, 'Electrical Measurements', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (221, 'Technical Mechanics', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (222, 'Electromechanical Devices', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (223, 'Introduction to MATLAB', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (224, 'Design of Electronic Equipment', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (225, 'Specialized Sports Training – Part 3', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (226, 'Sports Management – Part 1', 3, 100);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (227, 'Fundamentals of Automatic Control', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (228, 'Digital Circuitry', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (229, 'Analysis and Synthesis of Electronic Circuits', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (230, 'Information and Signal Theory', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (231, 'Technical Safety', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (232, 'Specialized Sports Training – Part 4', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (233, 'Sports Management – Part 2', 4, 100);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (234, 'Analog Circuitry', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (235, 'Testing and Verification of Electronic Devices', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (236, 'Microprocessor Systems – Part 1', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (237, 'Computer-Aided Electronics Design', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (238, 'Power Supply Devices', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (239, 'Elective Project: Analysis and Synthesis of Electronic Circuits', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (240, 'Elective Project: Design of Electronic Equipment', 5, 100);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (241, 'Conversion Technology', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (242, 'Microprocessor Systems – Part 2', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (243, 'Bioelectrical and Physiological Measurements in Humans', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (244, 'Programming for Hardware Design', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (245, 'Communication and Internet Technologies', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (246, 'Elective Project: Computer-Aided Electronics Design', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (247, 'Elective Project: Analog Circuitry', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (248, 'Specializing Practice', 6, 100);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (249, 'Digital Signal Processing', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (250, 'Sensor Technology', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (251, 'Industrial Electronics', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (252, 'Biophysics and Biomechanics', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (253, 'Imaging Diagnostic Equipment', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (254, 'Elective Project: Microprocessor Systems – Part 2', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (255, 'Elective Project: Conversion Technology', 7, 100);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (256, 'Medical Electronic Equipment', 8, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (257, 'Acquisition and Processing of Biomedical Signals', 8, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (258, 'Acquisition and Processing of Biomedical Images', 8, 100);


--Renewable Energy Sources
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (259, 'Mathematics – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (260, 'Programming and Computer Usage', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (261, 'Electrical Documentation', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (262, 'Materials Science Practicum', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (263, 'Foreign Language – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (264, 'Elective Subject: Specialized Sports Training – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (265, 'Elective Subject: Sport and Social Adaptation – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (266, 'Practical Training – Part 1', 1, 101);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (267, 'Mathematics – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (268, 'Physics', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (269, 'Electronics', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (270, 'Theoretical Electrical Engineering – Part 1', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (271, 'Foreign Language – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (272, 'Introduction to Renewable Energy Sources', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (273, 'Practical Training – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (274, 'Elective Subject: Specialized Sports Training – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (275, 'Elective Subject: Sport and Social Adaptation – Part 2', 2, 101);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (276, 'Electrical Engineering Materials', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (277, 'Electrical Measurements', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (278, 'Technical Mechanics', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (279, 'Theoretical Electrical Engineering – Part 2', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (280, 'Introduction to MATLAB', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (281, 'Thermodynamics and Heat Transfer', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (282, 'Practical Training – Part 3', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (283, 'Elective Subject: Specialized Sports Training – Part 3', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (284, 'Elective Subject: Sports Management – Part 1', 3, 101);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (285, 'Fundamentals of Automatic Control', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (286, 'Basic Course on Renewable Energy Sources', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (287, 'Hydraulics and Pneumatics', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (288, 'Machine Elements', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (289, 'Heat Exchange Equipment for Renewable Energy Systems', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (290, 'Industrial Chemistry', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (291, 'Elective Subject: Specialized Sports Training – Part 4', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (292, 'Elective Subject: Sports Management – Part 2', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (293, 'Practical Training – Part 4', 4, 101);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (294, 'Special Course on Renewable Energy Sources', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (295, 'Hydrokinetic and Cogeneration Systems', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (296, 'Photovoltaic Installations and Solar Power Plants', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (297, 'Electrical Machines – Part 1', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (298, 'Electrical Apparatus – Part 1', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (299, 'Power Electronics', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (300, 'Elective Subject: Lighting Installations', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (301, 'Elective Subject: Energy Security', 5, 101);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (302, 'Electrical Machines – Part 2', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (303, 'Electrical Apparatus – Part 2', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (304, 'Technical Safety', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (305, 'Heating Installations with Renewable Energy Sources', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (306, 'Relay Protection', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (307, 'Elective Subject: Lighting Installations', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (308, 'Elective Subject: Energy Security', 6, 101);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (309, 'Specialized Practice', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (310, 'Sensor Technology', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (311, 'Elective Project: Design of Renewable Energy Systems – Photovoltaics', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (312, 'Elective Subject: Project: Heating Installations with Renewable Energy Sources', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (313, 'Electrical Micromachines', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (314, 'Electrical Apparatus – Part 3', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (315, 'Wind Facilities and Systems', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (316, 'Electromechanical Systems', 7, 101);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (317, 'Operation, Diagnostics and Repair of Electrical Equipment for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (318, 'Elective Subject: Automation Systems for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (319, 'Programmable Controllers', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (320, 'Protection, Conservation and Reproduction of the Environment', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (321, 'Elective Subject: Electronic Systems for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (322, 'Electrotechnological Devices for Environmental Purposes', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (323, 'Production Management', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (324, 'Testing and Reliability in Renewable Energy Sources', 8, 101);

--Fleet and Port Operations
--Semestur 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (325, 'Higher Mathematics – Part 1', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (326, 'Computer Science and Computer Technology', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (327, 'Labour Protection and Technical Safety', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (328, 'Engineering Graphics', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (329, 'Elective: Specialized Sports Training – Part 1 or Sport and Social Adaptation – Part 1', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (330, 'English – Part 1', 1, 102);

--Semestur 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (331, 'Higher Mathematics – Part 2', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (332, 'Elective: Labor Legislation or Basics of Law', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (333, 'Technical Mechanics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (334, 'Physics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (335, 'Economics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (336, 'Elective: Specialized Sports Training – Part 2 or Sport and Social Adaptation – Part 2', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (337, 'English – Part 2', 2, 102);

--Semestur 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (338, 'Higher Mathematics – Part 3', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (339, 'Elective: Labor Legislation or Basics of Law', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (340, 'Technical Mechanics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (341, 'Physics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (342, 'Economics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (343, 'Elective: Specialized Sports Training – Part 3 or Sports Management – Part 1', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (344, 'English – Part 3', 3, 102);

--Semestur 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (345, 'Commodity Science', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (346, 'Machine Science', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (347, 'Elective: Labor Legislation or Basics of Law', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (348, 'Port Structure', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (349, 'Meteorology', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (350, 'Elective: Transport Marketing or Transport Management', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (351, 'English – Part 4', 4, 102);

--Semestur 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (352, 'Transport Equipment', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (353, 'English – Part 5', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (354, 'Marine Transport Technology', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (355, 'Maritime Law', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (356, 'Port Technologies', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (357, 'Reporting and Analysis of Operational Activity', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (358, 'Elective: Specialized Sports Training – Part 4 or Sports Management – Part 2', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (359, 'Specialized Internship – Part 1', 5, 102);

--Semestur 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (360, 'Organization and Management of Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (361, 'Commercial Operation of Fleet and Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (362, 'Technical Operation of Fleet and Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (363, 'Customs Control', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (364, 'English – Part 6', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (365, 'Specialized Internship – Part 2', 6, 102);

--Semestur 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (366, 'Ship Mechanization and Cargo Handling', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (367, 'Transport Logistics', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (368, 'Intermodal Transport Interaction', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (369, 'Port Management under Special Conditions', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (370, 'English – Part 7', 7, 102);

--Semestur 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (371, 'English – Part 8', 8, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (372, 'Electives: Sea Routes Geography, World Economy, Business Communication, Ethics, etc.', 8, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (373, 'State Exam Preparation', 8, 102);


--Power Engineering
--semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (374, 'Mathematics Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (375, 'Programming and Computer Usage', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (376, 'Technical Mechanics', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (377, 'Electrical Engineering Documentation', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (378, 'Foreign Language Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (379, 'Training Practice Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (380, 'Elective Course', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (381, 'Specialized Sports Training Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (382, 'Sports and Social Adaptation Part 1', 1, 42);

--semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (383, 'Mathematics Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (384, 'Theoretical Electrical Engineering Part 1', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (385, 'Physics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (386, 'Electronics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (387, 'Hydraulics and Pneumatics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (388, 'Electrical Engineering Materials', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (389, 'Foreign Language Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (390, 'Training Practice Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (391, 'Elective Course', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (392, 'Specialized Sports Training Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (393, 'Sports and Social Adaptation Part 2', 2, 42);

--semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (394, 'Theoretical Electrical Engineering Part 2', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (395, 'Electrical Measurements', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (396, 'Thermal Power Engineering', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (397, 'Electrical Machines and Devices Part 1', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (398, 'Foreign Language Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (399, 'Training Practice Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (400, 'Elective Course', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (401, 'Specialized Sports Training Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (402, 'Sports Management Part 1', 3, 42);

--semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (403, 'Lighting and Installation Technology', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (404, 'Digital and Microprocessor Technology', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (405, 'Electrical Machines and Devices Part 2', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (406, 'Modeling in Power Systems', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (407, 'Mechanical Part of Electrical Networks', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (408, 'Training Practice Part 4', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (409, 'Elective Course', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (410, 'Specialized Sports Training Part 4', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (411, 'Sports Management Part 2', 4, 42);

--semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (412, 'Electricity Production Technology', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (413, 'Electrical Networks and Systems', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (414, 'Mechanical Part of Electrical Networks Project', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (415, 'Short Circuits in Power Systems', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (416, 'Technical Safety', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (417, 'Electrical Part of Power Plants and Substations', 5, 42);

--semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (418, 'Electrical Networks and Systems Project', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (419, 'Electrical Networks in Settlements', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (420, 'Remote Control in Power Systems', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (421, 'Electrical Part of Power Plants and Substations Project', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (422, 'Relay Protection', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (423, 'Elective Course', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (424, 'Grounding and Lightning Protection Installations', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (425, 'Management', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (426, 'Enterprise Economics', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (427, 'Special Practice', 6, 42);

--semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (428, 'Power Systems Stability', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (429, 'High Voltage Technology', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (430, 'Construction of Power Objects', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (431, 'Remote Control in Power Systems Project', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (432, 'Power Systems Automation', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (433, 'Elective Course', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (434, 'Testing of Electrical Insulation Systems', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (435, 'Fundamentals of State and Law', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (436, 'Fundamentals of Management', 7, 42);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (437, 'Computer Research in Power Systems', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (438, 'Digital Relay Protection', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (439, 'Digital Relay Protection Project', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (440, 'Cable Diagnostics of Electrical Conductors', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (441, 'Organizational Psychology and Work Psychology', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (442, 'Creativity and Methods for Generating New Ideas', 8, 42);



-- Electronics
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (443, 'Mathematics – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (444, 'Programming and Computer Use', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (445, 'Electrical Documentation', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (446, 'Standards in Electronics', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (447, 'Foreign Language – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (448, 'Training Practice – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (449, 'Elective: Specialized Sports Training / Social Adaptation through Sports', 1, 43);

-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (450, 'Mathematics – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (451, 'Physics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (452, 'Electronics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (453, 'Theoretical Electrical Engineering', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (454, 'Foreign Language – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (455, 'Training Practice – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (456, 'Elective: Specialized Sports Training / Social Adaptation through Sports', 2, 43);

-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (457, 'Electrical Engineering Materials', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (458, 'Electrical Measurements', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (459, 'Technical Mechanics', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (460, 'Electromechanical Devices', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (461, 'Introduction to MATLAB', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (462, 'Design of Electronic Equipment', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (463, 'Elective: Specialized Sports Training / Sports Management', 3, 43);

-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (464, 'Basics of Automatic Control', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (465, 'Digital Circuitry', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (466, 'Analysis and Synthesis of Electronic Circuits', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (467, 'Theory of Information and Signals', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (468, 'Technical Safety', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (469, 'Elective: Specialized Sports Training / Sports Management', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (470, 'Analog Circuitry', 4, 43);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (471, 'Testing and Verification of Electronic Devices', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (472, 'Microprocessor Systems – Part 1', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (473, 'Computer-Aided Design in Electronics', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (474, 'Power Supply Devices', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (475, 'Elective Project: Circuit Analysis / Equipment Design', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (476, 'Converter Technology', 5, 43);

-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (477, 'Microprocessor Systems – Part 2', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (478, 'Measuring Electronics', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (479, 'Programming for Hardware Design', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (480, 'Communication and Internet Technologies', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (481, 'Elective Project: Computer-Aided Design / Analog Circuitry', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (482, 'Specialized Practice', 6, 43);

-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (483, 'Digital Signal Processing', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (484, 'Sensor Technology', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (485, 'Industrial Electronics', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (486, 'Automotive Electronics', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (487, 'Elective: Microelectronics / Imaging Diagnostics Equipment', 7, 43);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (488, 'Elective Project: Microprocessor Systems / Converter Technology', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (489, 'Medical Electronic Equipment', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (490, 'Elective: Intelligent Electronic Systems / Biomedical Signal Processing', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (491, 'Elective: Renewable Energy Electronic Systems / Biomedical Image Processing', 8, 43);


--Electrical Equipment of the Ship
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (492, 'Mathematics – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (493, 'Technical Mechanics', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (494, 'Electrical Documentation', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (495, 'English Language – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (496, 'Training Practice – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (497, 'Elective: Specialized Sports Training – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (498, 'Elective: Adapted Physical Activity', 1, 103);

-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (499, 'Physics', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (500, 'Theoretical Electrical Engineering – Part 1', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (501, 'Ship Theory and Construction', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (502, 'Electrical Materials', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (503, 'Industrial Chemistry', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (504, 'English Language – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (505, 'Training Practice – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (506, 'Elective: Specialized Sports Training – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (507, 'Elective: Adapted Physical Activity', 2, 103);

-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (508, 'Theoretical Electrical Engineering – Part 2', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (509, 'Electrical Measurements', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (510, 'Thermodynamics and Heat Transfer', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (511, 'Electrical Machines and Devices – Part 1', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (512, 'Computer-Aided Design', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (513, 'English Language – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (514, 'Training Practice – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (515, 'Elective: Specialized Sports Training – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (516, 'Elective: Adapted Physical Activity', 3, 103);

-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (517, 'Basics of Automation', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (518, 'Digital and Microprocessor Technology', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (519, 'Electrical Machines and Devices – Part 2', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (520, 'Ship Power Electronics – Part 1', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (521, 'Hydraulics and Pneumatics', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (522, 'Specialized English Language – Part 1', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (523, 'Training Practice – Part 4', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (524, 'Elective: Specialized Sports Training – Part 4', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (525, 'Elective: Adapted Physical Activity', 4, 103);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (526, 'Ship Electronic and Microprocessor Systems', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (527, 'Ship Power Electronics – Part 2', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (528, 'Ship Machines, Mechanisms, Systems, and Devices', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (529, 'Maritime Law', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (530, 'Specialized English Language – Part 2', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (531, 'Technical Safety', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (532, 'Training Practice – Part 5', 5, 103);

-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (533, 'Elements of Ship Automation', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (534, 'Electric Power Stations on Specialized Floating Objects', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (535, 'Ship Electric Power Systems – Part 1', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (536, 'Operation of Ship Electronic and Electrical Equipment – Part 1', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (537, 'Specialized English Language – Part 3', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (538, 'Training Practice – Part 6', 6, 103);

-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (539, 'Ship Electric Power Systems – Part 2', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (540, 'Electric Drive and Propulsion of the Ship – Part 1', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (541, 'High Voltage Technology', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (542, 'Ship Electric Power Systems – Project', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (543, 'Specialized English Language – Part 4', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (544, 'Training Technology and Simulator Practice', 7, 103);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (545, 'Comprehensive Ship Automation', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (546, 'Electric Drive and Propulsion of the Ship – Part 2', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (547, 'Installation, Maintenance, Diagnostics, and Repair of Ship Electrical Equipment', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (548, 'Operation of Ship Electronic and Electrical Equipment – Part 2', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (549, 'Specialized English Language – Part 5', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (550, 'Elective: Shipboard Practice', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (551, 'Elective: Industrial Training Practice', 8, 103);


--Power Supply and Electrical Equipment
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (552, 'Mathematics - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (553, 'Programming and Computer Usage', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (554, 'Technical Mechanics', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (555, 'Electrical Engineering Documentation', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (556, 'Foreign Language - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (557, 'Practical Training - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (558, 'Elective: Specialized Sports Training - Part 1 / Sports and Social Adaptation - Part 1', 1, 41);


-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (559, 'Mathematics - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (560, 'Physics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (561, 'Theoretical Electrical Engineering - Part 1', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (562, 'Electronics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (563, 'Hydraulics and Pneumatics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (564, 'Electrical Engineering Materials', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (565, 'Foreign Language - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (566, 'Practical Training - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (567, 'Elective: Specialized Sports Training - Part 2 / Sports and Social Adaptation - Part 2', 2, 41);


-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (568, 'Theoretical Electrical Engineering - Part 2', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (569, 'Electrical Measurements', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (570, 'Electrical Machines and Apparatus - Part 1', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (571, 'Thermal Power Engineering', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (572, 'Machine Elements and Mechanisms', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (573, 'CAD Systems in Power Supply and Electrical Equipment', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (574, 'Foreign Language - Part 3', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (575, 'Practical Training - Part 3', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (576, 'Elective: Specialized Sports Training - Part 3 / Sports Management - Part 1', 3, 41);


-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (577, 'Electrical Machines and Apparatus - Part 2', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (578, 'Digital and Microprocessor Technology', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (579, 'Lighting and Installation Technology', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (580, 'Electric Drives', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (581, 'Industrial Converters in Electrical Equipment - Part 1', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (582, 'Practical Training - Part 4', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (583, 'Elective: Specialized Sports Training - Part 4 / Sports Management - Part 2', 4, 41);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (584, 'Power Supply - Part 1', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (585, 'Industrial Converters in Electrical Equipment - Part 2', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (586, 'Electrical Part of Power Plants and Substations', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (587, 'Electrical Part of Power Plants and Substations - Project', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (588, 'High Voltage Technology', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (589, 'Technical Safety', 5, 41);


-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (590, 'Power Supply - Part 2', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (591, 'Electrical Equipment - Part 1', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (592, 'Lighting Installations', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (593, 'Automated Electric Drives', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (594, 'Relay Protection', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (595, 'Elective: Operation and Diagnostics of Electrical Installations or Law or Labor Risk Mgmt', 6, 41);


-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (597, 'Electrical Equipment - Part 2', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (598, 'Electronic and Microprocessor Systems for Industrial Equipment Control', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (599, 'Electric Transport', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (600, 'Elective: Transient Processes in Electrical Equipment / Labor Law / Production Management', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (601, 'Elective: Lighting Control or Industrial Law or Industrial Eng.', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (602, 'Electrical Equipment - Project', 7, 41);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (603, 'Computer Methods for Design and Research in Power Supply and Electrical Equipment', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (604, 'Elective: Electrical Equip. Prod. or Entrepreneurship or HR Management', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (605, 'Elective: Energy Efficiency / Energy Economy Organization / Quality Management', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (606, 'Power Supply - Project', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (607, 'Pre-Diploma Internship in the Specialty', 8, 41);


