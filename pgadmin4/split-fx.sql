-- Table-value function to split a full name into its components
CREATE OR REPLACE FUNCTION fn_parse_full-name(full_name_str character varying)
RETURNS TABLE 
(
    full_name   varchar(60),
    last_name   varchar(60),
    suffix      varchar(60),
    first_name  varchar(60),
    mi          varchar(60)
)
AS
$$
DECLARE
    -- Declare variables to hold the components of the full name
    last_name_str   varchar(60);
    first_name_str  varchar(60);
    suffix_str      varchar(60);
    mi_str          varchar(60);
    section_1       varchar(60);
    section_2       varchar(60);
    offset_1        integer;

BEGIN
    -- Split the full name into two sections
    section_1 := trim(SPLIT_PART(trim(full_name_str), ',', 1));
    section_2 := trim(SPLIT_PART(trim(full_name_str), ',', 2));

    -- Parse last name and suffix from section 1
    last_name_str := trim(section_1);

    IF POSITION(' ' IN trim(section_1)) > 0 THEN
        last_name_str := trim(SPLIT_PART(trim(section_1), ' ', 1));

        offset_1 := POSITION(' ' IN trim(section_1));
        suffix_str := trim(SUBSTRING(trim(section_1) FROM offset_1));

        IF upper(trim(suffix_str)) IN ('JR', 'SR', 'II', 'III', 'IV', 'V') THEN
            suffix_str := upper(trim(suffix_str));
        ELSE
            last_name_str := trim(section_1);
            suffix_str := NULL;
        END IF;

    END IF;

    -- Parse first name and middle initial or name from section 2
    IF POSITION(' ' IN trim(section_2)) > 0 THEN
        first_name_str := trim(SPLIT_PART(trim(section_2), ' ', 1));
        
        offset_1 := POSITION(' ' IN trim(section_2));
        RAISE NOTICE 'first_name_str: %', trim(first_name_str);
        RAISE NOTICE 'offset_1: %', offset_1;

        mi_str := trim(SUBSTRING(trim(section_2) FROM offset_1));
        RAISE NOTICE 'first_name_str: %', mi_str;

    ELSE
        first_name_str := trim(section_2);
    END IF;

    -- Insert the parsed components into the return table
    RETURN QUERY
    SELECT 
        full_name_str,
        last_name_str,
        suffix_str,
        first_name_str,
        mi_str;

    /*
    -- Debugging output
    RAISE NOTICE 'Full Name: %', full_name_str;
    RAISE NOTICE 'Last Name: %', last_name_str;
    RAISE NOTICE 'Suffix: %', suffix_str;
    RAISE NOTICE 'First Name: %', first_name_str;
    RAISE NOTICE 'Middle Initial: %', mi_str;
    */

END;
$$
language plpgsql;