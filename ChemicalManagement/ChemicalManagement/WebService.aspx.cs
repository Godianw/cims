using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChemicalManagement
{
    public partial class WebService : System.Web.UI.Page
    {
        string regis_name;
        string regis_pass;
        string regis_idcode;

        string login_name;
        string login_pass;

        string state;

        protected void Page_Load(object sender, EventArgs e)
        {
            regis_name = Request.Form["regis_username"];
            regis_pass = Request.Form["regis_password"];
            regis_idcode = Request.Form["regis_idcode"];

            login_name = Request.Form["log_username"];
            login_pass = Request.Form["log_password"];

            state = Request.Form["state"];
            Response.Clear();
            
            // 登陆
            if (login_name != null && login_pass != null)
            {
                string username = null;
                try
                {
                    username = Find_Username(login_name, login_pass);
                }
                catch(Exception)
                {
                    
                }
                
                if (username == null)   // 找不到匹配的用户
                {
                    Response.Write(-1);
                }
                else
                {
                    Session["username"] = username;
                    Response.Write(username);       
                }
            }

            // 注销
            if (state != null)
            {
                if (state == "register")
                {
                    // 注销后移除session中的username
                    Session.Remove("username");
                }
            }

            // 注册
            if (regis_name != null && regis_pass != null && regis_idcode != null)
            {
                try
                {
                    if (Register(regis_name, regis_pass))
                    {
                        // 检查验证码是否正确
                        Response.Write(1);
                    }
                    else    // 有重复的用户
                    {
                        Response.Write(-1);
                    }
                }
                catch(Exception)
                {
                    Response.Write(-1);
                }
            }

            // 文件上传
            if (Request.Files.Count > 0)
            {
                // 获取文件信息
                HttpPostedFile f = Request.Files[0];
                string met = Request.Params["met"];
                string comp = Request["comp"];
                string ind = Request.Form["ind"];

                if (met == "" || comp == "" || ind == "")
                {
                    Response.Write("{\"error\":\"文件信息不完整，请输入材料名称，公司名称和应用行业.\"}");
                    Response.End();
                    return;
                }

                CIMSDBEntities db = new CIMSDBEntities();

                // 检查材料名是否存在
                var record1 = db.Meterial.Where(p => p.met_name == met).ToList();
                if (record1?.Count <= 0)
                {
                    Meterial newMet = new Meterial()
                    {
                        met_name = met
                    };
                    db.Meterial.Add(newMet);
                }

                // 检查公司名是否存在
                var record2 = db.Company.Where(p => p.comp_name == comp).ToList();
                if (record2?.Count <= 0)
                {
                    Company newComp = new Company()
                    {
                        comp_name = comp
                    };
                    db.Company.Add(newComp);
                }

                // 检查应用行业是否存在
                var record3 = db.Industry.Where(p => p.ind_name == ind).ToList();
                if (record3?.Count <= 0)
                {
                    Industry newInd = new Industry()
                    {
                        ind_name = ind
                    };
                    db.Industry.Add(newInd);
                }

                try
                {
                    db.SaveChanges();
                }
                catch (Exception)
                {
                    Response.Write("{\"error\":\"文件路径错误.\"}");
                    Response.End();
                    return;
                }

                // 查看文件名是否重复
                string filename = f.FileName.Substring(0, f.FileName.Length - 4);
                var record = db.View_PDF.Where(p => p.met_name == met && p.comp_name == comp 
                && p.ind_name == ind && p.pdf_name == filename).ToList();
                if (record?.Count > 0)
                {
                    Response.Write("{\"error\":\"文件名已存在.\"}");
                    Response.End();
                    return;
                }

                // 更新数据库
                string currentTime = DateTime.Now.ToString("yyyy/MM/dd hh:mm:ss").Substring(2);
                int met_id = db.Meterial.Where(p => p.met_name == met).Select(s => s.met_id).First();
                int comp_id = db.Company.Where(p => p.comp_name == comp).Select(s => s.comp_id).First();
                int ind_id = db.Industry.Where(p => p.ind_name == ind).Select(s => s.ind_id).First();
                string address = "/PDF/" + met + "/" + comp + "/" + ind + "/"; 

                PDF newPdf = new PDF()
                {
                    pdf_name = filename,
                    pdf_uploadtime = currentTime,
                    pdf_met_id = met_id,
                    pdf_comp_id = comp_id,
                    pdf_ind_id = ind_id,
                    pdf_address = address
                };
                db.PDF.Add(newPdf);
                try
                {
                    db.SaveChanges();
                }
                catch (Exception)
                {
                    
                }

                // 保存文件到pdf文件中
                string savePath = address + f.FileName;
                string physicalPath = Request.PhysicalApplicationPath + address;
                if (!Directory.Exists(physicalPath))
                    Directory.CreateDirectory(physicalPath);
                f.SaveAs(Server.MapPath(savePath));

                // 将文件转化为swf文件备份在swf文件夹中
                int id = db.PDF.Where(p => p.pdf_name == newPdf.pdf_name && p.pdf_address == newPdf.pdf_address)
                        .Select(s => s.pdf_id).First();

                string swfPath = "/SWF/" + id + ".swf";
                PDF2SWF(savePath, swfPath);
                
                Response.Write("{\"filename\": \"" + f.FileName + "\"}");
            }

            Response.End();
        }

        public string Find_Username(string username, string password)
        {
            CIMSDBEntities db = new CIMSDBEntities();
            var record = db.Users.Where(p => p.user_name == username)
                .Where(p => p.user_password == password).Select(s => s.user_name).First().ToString();

            return record;
        }

        public bool Register(string username, string password)
        {
            CIMSDBEntities db = new CIMSDBEntities();
            Users newRecord = new Users()
            {
                user_name = username,
                user_password = password,
                user_group_id = 1
            };
            db.Users.Add(newRecord);

            try
            {
                db.SaveChanges();
            }
            catch(Exception)
            {
                return false;
            }

            return true;
        }

        // 将PDF文件转换成SWF文件
        private bool PDF2SWF(string pdfPath, string swfPath)
        {
            string pdf2swfexe = "D:\\swftools\\pdf2swf.exe";    // pdf2swf.exe所在目录
            string savePath = HttpContext.Current.Server.MapPath(swfPath);
            string filePath = HttpContext.Current.Server.MapPath(pdfPath);
            string args = " -t " + filePath + " -s flashversion=9 -o " + savePath; // 参数
                                                                                   //     ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('" + pdf2swfexe + "');</script>");
        //    ClientScript.RegisterStartupScript(GetType(), "message", "<script>alert('" + args + "');</script>");

            if (!System.IO.File.Exists(pdf2swfexe)
                || !System.IO.File.Exists(filePath))
                return false;

            // 执行转换命令
            Process p = new Process
            {
                StartInfo =
                {
                    FileName = pdf2swfexe,      // 执行的文件名
                    Arguments = args,           // 参数
                    UseShellExecute = false,
                    RedirectStandardError = true,
                    CreateNoWindow = false
                }
            };
            p.Start();
            p.BeginErrorReadLine();
            p.WaitForExit();
            p.Close();
            p.Dispose();

            return true;
        }
    }
}