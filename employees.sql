Use employees_mod;

select distinct gender from t_employees;
 
SELECT 
    YEAR(d.from_date) AS calender_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calender_year , e.gender
HAVING calender_year >= 1990
ORDER BY 1 , 3;

SELECT 
    d.dept_name,
    e.gender,
    YEAR(m.from_date) AS calender_year,
    COUNT(e.emp_no) AS number_of_employees
FROM
    t_employees e
        JOIN
    t_dept_manager m ON m.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = m.dept_no
GROUP BY calender_year , e.gender
HAVING calender_year >= 1990
ORDER BY 3;

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;


SELECT 
    d.dept_name,
    e.gender,
    YEAR(s.from_date) AS calender_year,
    ROUND(AVG(s.salary), 2) AS avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , calender_year , e.gender
HAVING calender_year <= 2002
ORDER BY d.dept_no;


delimiter $$
create procedure avg_salary(in lower_range float,in upper_range float)
begin
SELECT 
    d.dept_name, e.gender, ROUND(AVG(s.salary), 2) AS avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
WHERE
    s.salary BETWEEN lower_range AND upper_range
GROUP BY d.dept_no , e.gender;
end $$
delimiter ;

call avg_salary(50000,90000);





