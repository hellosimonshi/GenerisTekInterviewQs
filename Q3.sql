select email
from Employees
group by email
Having count(email) > 1