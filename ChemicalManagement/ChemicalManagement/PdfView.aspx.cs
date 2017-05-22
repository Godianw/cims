using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class PdfView : System.Web.UI.Page
    {
        public string uploadtime;

        protected void Page_Load(object sender, EventArgs e)
        {
       /*     string id = Request["id"];
            if (id != null)
            {
                CIMSDBEntities db = new CIMSDBEntities();
                int pdf_id = Convert.ToInt32(id);
                uploadtime = db.PDF.Where(p => p.pdf_id == pdf_id)
                    .Select(s => s.pdf_uploadtime).First();
                if (uploadtime != null)
                {
                    uploadtime = uploadtime.Replace("/", "");
                    uploadtime = uploadtime.Replace(":", "");
                    uploadtime = uploadtime.Replace(" ", "");
                }
            }*/
        }
    }
}