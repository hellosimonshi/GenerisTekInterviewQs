using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace ConsoleApp5
{
    class Program
    {
        static void Main(string[] args)
        {
 //           Console.WriteLine("Hello World!");

            Solution sol = new Solution();

            //           string[] emails = new String[] { "first.m.last@somewhere.com", "firstmlast@somewhere.com" };

            string[] emails = new String[] { "team1@somewhere.com", "team.1+bob@somewhere.com", "team1+jill+bob@somewhere.com", "team2@somewhere.com", "team2 @some.where.com" };
            //string[] emails = new String[] { "team1@somewhere.com", "team.1+bob@somewhere.com", "team1+jill+bob@somewhere.com"};
            Console.WriteLine(sol.NumberOfUniqueEmailAddresses(emails));

        }
    }

    public class Solution
    {
        public int NumberOfUniqueEmailAddresses(string[] emails)
        {
            int total = 0;
            var existEmails = new List<string>();
            foreach (var email in emails)
            {
                var atPos = email.IndexOf('@');
                if (atPos < 0 || atPos+1 == email.Length)
                    continue;
                var local = email.Substring(0, atPos);
                var domainName = email.Substring(atPos);

                var varPlusLoc = local.IndexOf('+');
                if (varPlusLoc > 0)
                    local = local.Substring(0, varPlusLoc);

                var notDot = Regex.Replace(local, "[.]+", "");

                var emailResult = notDot + domainName;

                if(!existEmails.Contains(emailResult))
                {
                    existEmails.Add(emailResult);
                    total++;
                }
            }
            return total;
        }
    }

}
