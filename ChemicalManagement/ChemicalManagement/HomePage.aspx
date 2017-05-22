<%@ Page MasterPageFile="~/MasterPage.Master" Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="ChemicalManagement.LoginPage" %>

<asp:Content ContentPlaceHolderId="CPH1" runat="server">

    <br /><br /><br />

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
                <asp:Button CssClass="btn btn-primary" id="searchBtn" runat="server"
                     OnClick="searchBtn_Click" Text="查询"></asp:Button>  
            </div>

        </div>

        <br /><br /><br />
 
    </div>


    <div class="container">
        <div id="example" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" 
            aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                        <h4 class="modal-title" id="myModalLabel">输入完整的文件信息并上传PDF文件</h4>
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
                        <p class="help-block">支持pdf格式，大小不超过4M</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id ="uploadFileDiv" class ="row">
        <div class="col-xs-3 col-xs-push-1 col-sm-3 col-sm-push-1 col-md-2 col-md-push-1">
            
        <p><a data-toggle="modal" href="#example" class="btn btn-primary btn-large">
           <span class="glyphicon glyphicon-plus" ></span> 添加新文件</a>
        </p>
    
        </div>
    </div>
    <br />

    <div class="container">
        <asp:GridView ID="pdf_GridView" runat="server" AutoGenerateColumns="False" GridLines="None"
            AllowPaging="True" CssClass="mGrid" PagerStyle-CssClass="pgr" 
            AlternatingRowStyle-CssClass="alt" DataKeyNames="pdf_id" 
            ShowHeaderWhenEmpty="True" EmptyDataText="找不到相关记录"
            OnRowDeleting="pdf_GridView_RowDeleting">    
            <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
            <Columns>
                <asp:BoundField DataField="pdf_id" HeaderText="编号" InsertVisible="False" 
                    ReadOnly="True" SortExpression="pdf_id" />
                 <asp:HyperLinkField DataNavigateUrlFields="pdf_id" 
                     DataNavigateUrlFormatString="PdfView.aspx?id={0}"  
                     DataTextField="pdf_name" HeaderText="文件名" Target="_blank" 
                     SortExpression="pdf_name">
                </asp:HyperLinkField>
                <asp:BoundField DataField="pdf_uploadtime" HeaderText="上传时间"
                    SortExpression="pdf_uploadtime" />
                <asp:BoundField DataField="met_name" HeaderText="材料名称" SortExpression="met_name" />
                <asp:BoundField DataField="comp_name" HeaderText="公司名称" SortExpression="comp_name" />
                <asp:BoundField DataField="ind_name" HeaderText="应用行业" SortExpression="ind_name" />
                
                <asp:CommandField HeaderText="删除" ShowDeleteButton="True"
                    DeleteText="<div onclick=&quot;JavaScript:return confirm('文件删除后将无法恢复，确认要删除吗?')&quot;>删除该文件<div/>" />
            
            </Columns>

            <PagerStyle CssClass="pgr"></PagerStyle>
        </asp:GridView>    
    </div>

    <link type="text/css" rel="stylesheet" href="bootstarp/css/fileinput.css"/>
    <script type="text/javascript" src="bootstarp/js/fileinput.js"></script>
    <script type="text/javascript" src="bootstarp/js/fileinput.min.js"></script>
    <script type="text/javascript" src="bootstarp/js/fileinput_locale_zh.js"></script>
    <script type="text/javascript">

        function onload2() {
            //0.初始化fileinput
            var oFileInput = new FileInput();
            oFileInput.Init("pdf_file", "WebService.aspx");
        };

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

