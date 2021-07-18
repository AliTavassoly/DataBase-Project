/*
on insert to advertisment_related_skills insert into new_add_notif
on insert to HW_Delivary and course.is_public = false , check if user is a participants.
*/

-- DROP TRIGGER QueraEcoPlus.new_adv_notif;
CREATE TRIGGER QueraEcoPlus.new_adv_notif AFTER INSERT ON QueraEcoPlus.ADV_RELATIVE_SKILLS
FOR EACH ROW BEGIN
    DECLARE i INT;
    DECLARE n INT;
    DECLARE user_id INT;
    DECLARE not_id INT;
    SET i = 0;
    SELECT count(DISTINCT CV_WORK_INFO_INTRESTS.USER_ID) FROM QueraEcoPlus.CV_WORK_INFO_INTRESTS 
        WHERE CV_WORK_INFO_INTRESTS.SKILL_NAME = NEW.SKILL_NAME INTO n;
    WHILE i < n DO
        SELECT USER_ID FROM QueraEcoPlus.CV_WORK_INFO_INTRESTS WHERE CV_WORK_INFO_INTRESTS.SKILL_NAME = NEW.SKILL_NAME LIMIT i,1 INTO user_id;
        SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_SCHEMA = "QueraEcoPlus"
                AND TABLE_NAME = 'NOTIFICATION' INTO not_id;
        INSERT INTO NOTIFICATION(CREATION_DATE, BODY) VALUES(CURRENT_TIME, 'new job offer');
        INSERT INTO USER_NOTIFICATION VALUES(not_id, user_id);
        INSERT INTO NEW_ADD_NOTIF VALUES(not_id, NEW.COMPANY_REGISTRATION_ID, NEW.ADD_ID);
        SET i = i + 1;
    END WHILE;
END;

CREATE TRIGGER QueraEcoPlus.request_status_update AFTER UPDATE QueraEcoPlus.REQUESTS.STATUS ON QueraEcoPlus.REQUESTS
FOR EACH ROW BEGIN
    DECLARE not_id INT;
    SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = "QueraEcoPlus"
            AND TABLE_NAME = 'NOTIFICATION' INTO not_id;
    INSERT INTO NOTIFICATION(CREATION_DATE, BODY) VALUES(CURRENT_TIME, 'request status update');
    INSERT INTO USER_NOTIFICATION VALUES(not_id, NEW.USER_ID);
    INSERT INTO REQUEST_STATUS_UPDATE VALUES(not_id, NEW.USER_ID, NEW.COMPANY_REGISTRATION_ID, NEW.ADD_ID);
END;

CREATE TRIGGER QueraEcoPlus.new_request AFTER INSERT ON QueraEcoPlus.REQUESTS
FOR EACH ROW BEGIN
    DECLARE not_id INT;
    SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = "QueraEcoPlus"
            AND TABLE_NAME = 'NOTIFICATION' INTO not_id;
    INSERT INTO NOTIFICATION(CREATION_DATE, BODY) VALUES(CURRENT_TIME, 'new request');
    INSERT INTO NEW_REQUEST_NOTIF VALUES(not_id, NEW.USER_ID, NEW.COMPANY_REGISTRATION_ID, NEW.ADD_ID);
END;

CREATE TRIGGER QueraEcoPlus.new_solved_problem AFTER INSERT ON QueraEcoPlus.SUBMISSION
FOR EACH ROW BEGIN
    INSERT INTO ACTIVITY_HISTORY_PROBLEMS VALUES(NEW.USER_ID, NEW.PROBLEM_ID, NEW.SCORE);
END;

CREATE TRIGGER QueraEcoPlus.new_contest_participant AFTER INSERT ON QueraEcoPlus.CONTEST_PARTICIPANTS
FOR EACH ROW BEGIN
    INSERT INTO ACTIVITY_HISTORY_CONTEST VALUES(NEW.USER_ID, NEW.CONTEST_ID, NEW.SCORE, NEW.RANK);
END;

CREATE TRIGGER QueraEcoPlus.new_contest_participant AFTER UPDATE [QueraEcoPlus.CONTEST_PARTICIPANTS.SCORE, QueraEcoPlus.CONTEST_PARTICIPANTS.RANK] ON QueraEcoPlus.CONTEST_PARTICIPANTS
FOR EACH ROW BEGIN
    UPDATE ACTIVITY_HISTORY_CONTEST SET ACTIVITY_HISTORY_CONTEST.SCORE = NEW.SCORE, ACTIVITY_HISTORY_CONTEST.RANK = NEW.RANK
    WHERE NEW.USER_ID = ACTIVITY_HISTORY_CONTEST.USER_ID AND NEW.CONTEST_ID = ACTIVITY_HISTORY_CONTEST.CONTEST_ID;
END;

SELECT * FROM INFORMATION_SCHEMA.TRIGGERS;