select d.name Department, e.name Employee, salary
from Employees as e
Join (select Max(salary) as highest, DepartmentId from employees group by departmentId) as b
ON e.departmentId = b.departmentId AND salary = b.highest
Join Department as d on e.departmentId = d.departmentId
