-- Lặp một chuỗi và xử lý dữ liệu với các phần tử trong chuỗi phân tách nhau bởi dấu ";"
CREATE DEFINER = 'root' @'localhost' PROCEDURE classicmodels.Proc_GetListCountriesStrByListCytiesStr(IN v_listContriesStr text) BEGIN
DECLARE currentCity text DEFAULT NULL;
DECLARE currentLength int DEFAULT 1;
DECLARE returnValue text DEFAULT NULL;
DECLARE tmpValue text DEFAULT NULL;
loop_label: LOOP IF CHAR_LENGTH(TRIM(v_listContriesStr)) = 0
OR v_listContriesStr IS NULL THEN LEAVE loop_label;
END IF;
SET currentCity = SUBSTRING_INDEX(v_listContriesStr, ';', 1);
SET currentLength = CHAR_LENGTH(currentCity);
SET v_listContriesStr =
INSERT(v_listContriesStr, 1, currentLength + 1, '');
IF (
    SELECT EXISTS (
            SELECT 1
            FROM offices o
            WHERE o.city = currentCity
            LIMIT 1
        )
) = 0 THEN ITERATE loop_label;
END IF;
SELECT o.country INTO tmpValue
FROM offices o
WHERE o.city = currentCity
LIMIT 1;
IF CHAR_LENGTH(tmpValue) = 0
OR tmpValue IS NULL THEN ITERATE loop_label;
ELSEIF returnValue IS NULL THEN
SET returnValue = tmpValue;
ELSE
SET returnValue = CONCAT_WS(';', returnValue, tmpValue);
END IF;
END LOOP;
SELECT returnValue AS result;
END