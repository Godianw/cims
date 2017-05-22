using System;
using System.Collections.Generic;
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

        // 查询数据
        protected void searchBtn_Click(object sender, EventArgs e)
        {
            string selectedMet;
            string selectedComp;
            string selectedInd;

            CIMSDBEntities db = new CIMSDBEntities();
            var records = (IEnumerable<View_PDF>)db.View_PDF;
            if (selectedMetIndex != 0)
            {
                selectedMet = met_type.Items[selectedMetIndex].Text;
                records = records.Where(p => p.met_name == selectedMet);
            }
            if (selectedCompIndex != 0)
            {
                selectedComp = comp_type.Items[selectedCompIndex].Text;
                records = records.Where(p => p.comp_name == selectedComp);
            }
            if (selectedIndIndex != 0)
            {
                selectedInd = ind_type.Items[selectedIndIndex].Text;
                records = records.Where(p => p.ind_name == selectedInd);
            }

            var result = records.ToList();
            pdf_GridView.DataSource = result;
            pdf_GridView.DataBind();
        }

        protected void pdf_GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            /* 删除数据 */
            CIMSDBEntities db = new CIMSDBEntities();
            string _id = pdf_GridView.Rows[e.RowIndex].Cells[0].Text;
            PDF delRecoed = new PDF() { pdf_id = Convert.ToInt32(_id) };
            db.PDF.Attach(delRecoed);
            db.PDF.Remove(delRecoed);
            try
            {
                db.SaveChanges();
            }
            catch(Exception)
            {
                ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('文件不存在');</script>");
            }
        }
    }
}