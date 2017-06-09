<%@ Page MasterPageFile="~/MasterPage.Master" Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="ChemicalManagement.LoginPage" %>

<asp:Content ContentPlaceHolderId="CPH1" runat="server">

    <br /><br />

    <div class="conrainer page-header">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-10 col-xs-push-1 col-sm-10 col-sm-push-1 col-md-10 col-md-push-1 ">
                <h2>主页
                    <small>Home Page</small>
                </h2>
            </div>
        </div>
    </div>
    
    <br />

    <div class="conrainer"">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-1 ">   
                <div class="form-group"> 
                    <select id="met_type" name="met_type" class="selectpicker show-tick form-control" 
                        data-live-search="false" runat="server">
                        <option value="0">--材料名称--</option>
                    </select>
                </div>
            </div>

            <!-- 公司名 -->
            <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-2 ">     
                <div class="form-group"> 
                    <select id="comp_type" name="comp_type" class="selectpicker show-tick form-control" 
                        data-live-search="false" runat="server">
                        <option value="0">--公司名称--</option>
                    </select>
                </div>
            </div>

            <!-- 应用行业 -->
            <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-3 ">       
                <div class="form-group"> 
                    <select id="ind_type" name="ind_type" class="selectpicker show-tick form-control" 
                        data-live-search="false" runat="server">
                        <option value="0">--应用行业--</option>
                    </select>
                </div>
            </div>

            <!-- 查询按钮 -->
            <div class="col-xs-2 col-xs-push-1 col-sm-2 col-sm-push-1 col-md-2 col-md-push-4 ">  
                <input id="searchBtn" type="button" class="btn btn-primary" 
                    onclick="searchBtn_click()" value="查询" />    
            </div>

        </div>

        <br /><br /><br />
 
    </div>


    <div class="container">
        <div id="newFileDialog" class="modal fade" data-backdrop="static" tabindex="-1" 
            role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            输入完整的文件信息并上传PDF文件
                        </h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label>材料名称：</label>
                            <input type="text" class="form-control" id="met" name="met" 
                                placeholder="材料名称" value="" />
                        </div>
                        <div class="form-group">
                            <label>公司名称：</label>
                            <input type="text" class="form-control" id="comp" name="comp" 
                                placeholder="公司名称" value="" />
                        </div>
                        <div class="form-group">
                            <label>应用行业：</label>
                            <input type="text" class="form-control" id="ind" name="ind" 
                                placeholder="应用行业" value="" />
                        </div>
                        <input type="file" name="pdf_file" id="pdf_file" multiple="multiple" 
                            class="file-loading" value="" accept="application/pdf" />
                        <p class="help-block">支持pdf格式，大小不超过100M</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id ="uploadFileDiv" class ="row" runat="server">
        <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-1">
            
        <p><a data-toggle="modal" href="#newFileDialog" class="btn btn-primary btn-large">
           <span class="glyphicon glyphicon-plus" ></span> 添加新文件</a>
        </p>
    
        </div>
    </div>
    <br />

    <div class="container">
 
        <table class="table" id="searchResult_Tb">
            <caption>查询结果</caption>
            <thead>
                <tr>
                    <th>文件名</th>
                    <th>上传时间</th>
                    <th>材料名称</th>
                    <th>公司名称</th>
                    <th>应用行业</th>
                </tr>
            </thead>
            <tbody id ="tb_body" style="font-family:'微软雅黑'; font-weight:lighter;">
                
            </tbody>
        </table>

        <ul id="pageDiv" class="pagination">

        </ul>
    </div>

    <link type="text/css" rel="stylesheet" href="bootstarp/css/fileinput.css"/>
    <script type="text/javascript" src="bootstarp/js/fileinput.js"></script>
    <script type="text/javascript" src="bootstarp/js/fileinput.min.js"></script>
    <script type="text/javascript" src="bootstarp/js/fileinput_locale_zh.js"></script>
    <script type="text/javascript">

        var curMet;
        var curComp;
        var curInd;
        var def_PageSize = 10;

        function onload2() {

            //0.初始化fileinput
            var oFileInput = new FileInput();
            oFileInput.Init("pdf_file", "WebService.aspx");
        };

        function searchBtn_click() {

            var def_curPage = 1;    // 当前页默认为1

            /* 材料名称 */
            var metSelected = document.getElementById('<%=met_type.ClientID%>');
            var met_type;
            if (metSelected.selectedIndex != 0)
                met_type = $('#<%=met_type.ClientID%>').val();
            else
                met_type = "";

            /* 公司名称 */
            var compSelected = document.getElementById('<%=comp_type.ClientID%>');
            var comp_type;
            if (compSelected.selectedIndex != 0)
                comp_type = $('#<%=comp_type.ClientID%>').val();
            else
                comp_type = "";

            /* 应用行业 */
            var indSelected = document.getElementById('<%=ind_type.ClientID%>');
            var ind_type;
            if (indSelected.selectedIndex != 0)
                ind_type = $('#<%=ind_type.ClientID%>').val();
            else
                ind_type = "";

            curMet = met_type;
            curComp = comp_type;
            curInd = ind_type;
            turnToPage(def_curPage);
        };

        function turnToPage(def_curPage) {

            $.ajax({
                type: 'POST',
                url: 'DataService.aspx',
                async: false,
                data: {
                    pageSize: def_PageSize,
                    currentPage: def_curPage,
                    met: curMet,
                    comp: curComp,
                    ind: curInd
                },
                beforeSend: function () {
                    // 禁用按钮防止重复提交
                    $("#searchBtn").attr({ disabled: "disabled" });
                },
                success: function (data) {         
                    document.getElementById("tb_body").innerHTML = "";
                    document.getElementById("pageDiv").innerHTML = "";

                    if (data == "]")
                    {
                        document.getElementById("tb_body").innerHTML = "<tr><th>找不到相关记录</th></tr>";
                        return;
                    }

                    var totalCount;
                    $.each($.parseJSON(data), function (index, obj) {
                        totalCount = obj.totalCount;

                        var html = "<tr><th style=\"display:none\">" + obj.pdf_id
                            + "</th><th><a href=\"/PdfView.aspx?id=" + obj.pdf_id
                            + "\" target=\"_blank\">" + obj.pdf_name + "</a></th><th>"
                            + "20" + obj.pdf_uploadtime + "</th><th>" + obj.met_name
                            + "</th><th>" + obj.comp_name + "</th><th>" + obj.ind_name + "</th>";

                        var session = '<%=Session["username"] %>';
                        if (session == "admin")
                            html += "<th><a href=\"javascript:void(0)\""
                            + "onclick=\"delBtn_click()\">删除</a></th>";

                        html += "</tr>";
                        document.getElementById("tb_body").innerHTML += html; 
                    });

                    var pageCount = totalCount / 10 + ((totalCount % 10) > 0 ? 1 : 0);   
                    for (var i = 1; i <= pageCount; ++ i)
                    {
                        var html = "<li><a href=\"javascript:void(0)\" onclick=\"turnToPage("
                            + i + ")\">"+ i + "</a></li>";
                        document.getElementById("pageDiv").innerHTML += html;
                    }
                },
                error: function () {
                    alert("查询失败");
                },
                complete: function () {
                    $("#searchBtn").removeAttr("disabled");
                }
            });
        }

        function delBtn_click() {

            if (!confirm("文件删除后将无法恢复，确认要删除吗?"))
                return;

            var tr = event.srcElement.parentNode.parentElement; // 通过event.srcelement 获取激活事件的对象 td  
       //     alert("行号：" + (tr.rowIndex) + "，id：" + tr.firstElementChild.innerHTML);

            $.ajax({
                type: 'POST',
                url: 'DataService.aspx',
                async: false,
                data: {
                    delRow_Id: tr.firstElementChild.innerHTML
                },
                beforeSend: function () {
                    // 禁用按钮防止重复提交
               //     $("#searchBtn").attr({ disabled: "disabled" });
                },
                success: function (data) {
                    alert('删除成功');
                },
                error: function () {
                    alert("删除失败");
                },
                complete: function () {
                    $('#searchBtn').click();
            //        $("#searchBtn").removeAttr("disabled");
                }
            });
        }

        //初始化fileinput
        var FileInput = function () {
            var oFile = new Object();
            //初始化fileinput控件（第一次初始化）
            oFile.Init = function(ctrlName, uploadUrl) {
                var control = jQuery('#' + ctrlName);
                //初始化上传控件的样式
                control.fileinput({
                    language: 'zh',         //设置语言
                    uploadUrl: uploadUrl,   //上传的地址
                    allowedFileExtensions: ['pdf'],//接收的文件后缀
                    showUpload: false,      // 显示上传按钮
                    showRemove: false,      // 不显示删除文件按钮
                    showCaption: false,     // 不显示标题
                    showPreview: true,      // 显示预览
                    browseClass: "btn btn-primary", //按钮样式 
                    uploadAsync: true,      //默认异步上传
                    //dropZoneEnabled: false,//是否显示拖拽区域
                    //minImageWidth: 50, //图片的最小宽度
                    //minImageHeight: 50,//图片的最小高度
                    //maxImageWidth: 1000,//图片的最大宽度
                    //maxImageHeight: 1000,//图片的最大高度
                    //maxFileSize: 0,//单位为kb，如果为0表示不限制文件大小
                    //minFileCount: 0,
                    maxFileCount: 10,       //表示允许同时上传的最大文件个数
                    enctype: 'multipart/form-data',
                    validateInitialCount:true,
                    previewFileIcon: "<i class='glyphicon glyphicon-file'></i>",
                    msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
                    uploadExtraData: function(previewId, index) {   //额外参数的关键点
                        var obj = {};
                        obj.met = jQuery('#met').val();
                        obj.comp = jQuery('#comp').val();
                        obj.ind = jQuery('#ind').val();
                        console.log(obj);
                        return obj;
                    },
                })
                //异步上传返回错误结果处理
                .on('fileerror', function(event, data, msg) {
                    // get message
                    alert("文件上传时出现未知错误.");
              //      alert(JSON.stringify(data.returnCode));
                })
                //异步上传返回结果处理
                .on("fileuploaded", function (event, data, previewId, index) {
                    alert("上传成功.")
                })
                //批量同步上传错误处理
                .on('filebatchuploaderror', function(event, data, msg) {
                    // get message
                    alert("文件上传时出现未知错误.");
                })
                //批量同步上传成功结果处理
                .on("filebatchuploadsuccess", function (event, data, previewId, index) {
                    var obj = data.response;
                    alert("上传成功.");
                })
                //上传前
                .on('filepreupload', function (event, data, previewId, index) {
                    console.log('File pre upload triggered');
                    
                });
            }
            return oFile;
        };
    </script>

</asp:Content>

