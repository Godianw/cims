using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class DataService : System.Web.UI.Page
    {
        string met;
        string comp;
        string ind;

        protected void Page_Load(object sender, EventArgs e)
        {
            string pageSize = Request.Form["pageSize"];
            string currentPage = Request.Form["currentPage"];
            met = Request.Form["met"];
            comp = Request.Form["comp"];
            ind = Request.Form["ind"];

            string delRow_Id = Request.Form["delRow_Id"];

            if (pageSize != null && currentPage != null)
            {
                int _pageSize = Convert.ToInt32(pageSize);
                int _currentPage = Convert.ToInt32(currentPage);
                int sectionLower = _pageSize * (_currentPage - 1) + 1;
                int sectionUpper = _pageSize  * _currentPage;

                SqlConnection conn = new SqlConnection("server=.;database=CIMSDB;uid=test;pwd=000000");
                conn.Open();

                string sql = "SELECT * FROM (SELECT row_number() over (ORDER BY"
                    + " pdf_uploadtime DESC) rownumber, * FROM View_PDF WHERE 1 = 1";

                SqlCommand cmd = new SqlCommand();
                if (met != "")
                {
                    sql += " AND met_name = @met";
                    cmd.CommandText = sql;
                    cmd.Parameters.Add(new SqlParameter("@met", met));
                }
                if (comp != "")
                {
                    sql += " AND comp_name = @comp";
                    cmd.CommandText = sql;
                    cmd.Parameters.Add(new SqlParameter("@comp", comp));
                }
                if (ind != "")
                {
                    sql += " AND ind_name = @ind";
                    cmd.CommandText = sql;
                    cmd.Parameters.Add(new SqlParameter("@ind", ind));
                }

                sql += ") as tmpTb WHERE rownumber > " + (sectionLower - 1) 
                    + " AND rownumber < " + (sectionUpper + 1);
                cmd.CommandText = sql;
                cmd.Connection = conn;
                SqlDataReader reader = cmd.ExecuteReader();
                string json = DataReader2Json(reader);
                
                Response.Write(json);
                Response.End();

                conn.Close();
            }

            if (delRow_Id != null)
            {
                CIMSDBEntities db = new CIMSDBEntities();
                PDF delRecoed = new PDF() { pdf_id = Convert.ToInt32(delRow_Id) };
                db.PDF.Attach(delRecoed);
                db.PDF.Remove(delRecoed);
                try
                {
                    db.SaveChanges();
                }
                catch (Exception)
                {
                    ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('文件不存在');</script>");
                    return;
                }
            }
        }

        // 数据
        protected int getRecordsCount()
        {
            CIMSDBEntities db = new CIMSDBEntities();
            var records = (IEnumerable<View_PDF>)db.View_PDF;
            if (met != "")
            {
                records = records.Where(p => p.met_name == met);
            }
            if (comp != "")
            {
                records = records.Where(p => p.comp_name == comp);
            }
            if (ind != "")
            {
                records = records.Where(p => p.ind_name == ind);
            }

            if (records?.Count() >= 0)
                return records.Count();

            return 0;
        }

        public string DataReader2Json(SqlDataReader reader)
        {
            StringBuilder jsonBuilder = new StringBuilder();

            int totalCount = getRecordsCount();
            jsonBuilder.Append("[");
            while(reader.Read())
            {
                jsonBuilder.Append("{\"totalCount\":\"");
                jsonBuilder.Append(totalCount);
                jsonBuilder.Append("\",");
                for (int i = 0; i < 7; ++ i)
                {
                    if (i == 0)
                        continue;

                    jsonBuilder.Append("\"");
                    string[] colFieldName = { "", "pdf_id", "pdf_name", "pdf_uploadtime", "met_name", "comp_name", "ind_name" };
                    jsonBuilder.Append(colFieldName[i]);
                    jsonBuilder.Append("\":\"");
                    jsonBuilder.Append(reader[i].ToString());
                    jsonBuilder.Append("\",");
                }
                jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
                jsonBuilder.Append("},");
            }
            jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            jsonBuilder.Append("]");

            return jsonBuilder.ToString();
        }
    }
}