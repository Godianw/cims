<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MessageBoard.aspx.cs" Inherits="ChemicalManagement.MessageBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPH1" runat="server">

    <br /><br />

    <div class="conrainer page-header">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-10 col-xs-push-1 col-sm-10 col-sm-push-1 col-md-10 col-md-push-1 ">
                <h2>留言板
                    <small>Message Board</small>
                </h2>
            </div>
        </div>
    </div>
    
    <br />

    <div class="container">
        <div class="row">
            <!-- 材料名称 -->
            <div class="col-xs-10 col-xs-push-1 col-sm-10 col-sm-push-1 col-md-10 col-md-push-1 ">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">留言板</h3>
                    </div>
                    <ul class="panel-body list-group" id="messageBoard" runat="server">
                        <!-- 后台动态添加 -->

                    </ul>

                    <br />
                    <br />
                </div>
                <div class="form-group">
                    <label for="name">留言：</label>
                    <textarea class="form-control input-sm" rows="5" maxlength="100"
                        style="resize:none" placeholder="只有登录的用户才能留言" 
                        readonly="readonly" runat="server" id="msgTextArea"></textarea>
                </div>

                <div>
                    <asp:Button CssClass="btn btn-warning" ID="msgBtn" runat="server"
                        OnClick="msgBtn_Click" Text="发表留言"></asp:Button>
                    <label for="name">不能超过100个字</label>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">


        function onload2() {
            var session = '<%=Session["username"] %>';
            if (session != null && session != "")
            {
                if (session == "admin")
                {
                    $('#msgTextDiv').hide();
                    $('#msgBtnDiv').hide();
                }
                else
                {
                    $('#msgTextDiv').show();
                    $('#msgBtnDiv').show();
                }

                var textArea = document.getElementById("<%=msgTextArea.ClientID %>");
                textArea.readOnly = false;
                textArea.placeholder = "不超过100个字";
            }
            else
            {
                var textArea = document.getElementById("<%=msgTextArea.ClientID %>");
                textArea.readOnly = true;
                textArea.placeholder = "只有登录的用户才能回复";
            }
        };

    </script>

</asp:Content>
