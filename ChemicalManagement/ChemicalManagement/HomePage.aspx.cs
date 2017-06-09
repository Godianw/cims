using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class LoginPage : System.Web.UI.Page
    {
        int selectedMetIndex;
        int selectedCompIndex;
        int selectedIndIndex;

        protected void Page_Load(object sender, EventArgs e)
        {
            selectedMetIndex = met_type.SelectedIndex;
            selectedCompIndex = comp_type.SelectedIndex;
            selectedIndIndex = ind_type.SelectedIndex;

            // 为选择框添加项
            addMeterial();
            addCompany();
            addIndustry();
        }

        /* 添加材料名称 */
        protected void addMeterial()
        {
            met_type.Items.Clear();
            met_type.Items.Add("--材料名称--");

            CIMSDBEntities db = new CIMSDBEntities();
            var records = db.Meterial.Where(p => p.met_id != 0);
            foreach (var singleRecord in records)
            {
                met_type.Items.Add(new ListItem(singleRecord.met_name.ToString()));
            }
        }

        /* 添加公司名称 */
        protected void addCompany()
        {
            comp_type.Items.Clear();
            comp_type.Items.Add("--公司名称--");

            CIMSDBEntities db = new CIMSDBEntities();
            var records = db.Company.Where(p => p.comp_id != 0);
            foreach (var singleRecord in records)
            {
                comp_type.Items.Add(new ListItem(singleRecord.comp_name.ToString()));
            }
        }

        /* 添加应用行业 */
        protected void addIndustry()
        {
            ind_type.Items.Clear();
            ind_type.Items.Add("--应用行业--");

            CIMSDBEntities db = new CIMSDBEntities();
            var records = db.Industry.Where(p => p.ind_id != 0);
            foreach (var singleRecord in records)
            {
                ind_type.Items.Add(new ListItem(singleRecord.ind_name.ToString()));
            }
        }
        
    }
}