 <%@ Page MasterPageFile="~/MasterPage.Master" Language="C#" AutoEventWireup="true" CodeBehind="PdfView.aspx.cs" Inherits="ChemicalManagement.PdfView" %>


<asp:Content ContentPlaceHolderId="CPH1" runat="server">
    <br /><br /><br />


 
    <div style="top: 50px; margin-left: 10%; width: 80%; height: 500px"
        id="documentViewer" class="flexpaper_viewer">
        <script type="text/javascript">

            window.onload2 = function () {
                
                var url = window.location.search;
                var id = "";
                if (url != null)
                {
                    id = url.split("=")[1];
                }
                if (id == "")
                {
                    alert("找不到该文件，该文件可能已经删除.");
                    return;
                }

                var fileName = 'SWF/' + id + '.swf';
                jQuery.noConflict();
                jQuery('#documentViewer').FlexPaperViewer(
                {
                    config: {
                        SwfFile: decodeURI(fileName),
                        Scale: 1,
                        ZoomTransition: 'easeOut',
                        ZoomTime: 0.5,
                        ZoomInterval: 0.1,
                        FitPageOnLoad: true,
                        FitWidthOnLoad: true,
                        FullScreenAsMaxWindow: false,
                        ProgressiveLoading: false,
                        MinZoomSize: 0.2,
                        MaxZoomSize: 5,
                        SearchMatchAll: false,
                        InitViewMode: 'Portrait',
                        RenderingOrder: 'flash',

                        ViewModeToolsVisible: false,
                        ZoomToolsVisible: false,
                        NavToolsVisible: false,
                        CursorToolsVisible: false,
                        SearchToolsVisible: false,
                        localeChain: 'zh_CN'
                    }
                });
            };
        </script>
    </div>

    
    <script type="text/javascript" src="js/flexpaper.js"></script>
    <script type="text/javascript" src="js/flexpaper_handlers.js"></script>
    
    <br /><br /><br />



</asp:Content>
