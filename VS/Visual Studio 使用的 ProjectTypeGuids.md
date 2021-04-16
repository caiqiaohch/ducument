Visual Studio 使用的 ProjectTypeGuids

  Visual Studio 所使用的 *.sln,*.csproj,*.vbproj 等文件表示项目类型的 GUID 列表。
  对于分析项目信息很有用。

    < ProjectTypeGuids>{60dc8134-eba5-43b8-bcc9-bb4bc16c2548};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}
  以后如有更多的项目类型，我会补上。

Project Type Description	Project Type Guid
Windows (C#)	{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}
Windows (VB.NET)	{F184B08F-C81C-45F6-A57F-5ABD9991F28F}
Windows (Visual C++)	{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}
Web Application	{349C5851-65DF-11DA-9384-00065B846F21}
Web Site	{E24C65DC-7377-472B-9ABA-BC803B73C61A}
Distributed System	{F135691A-BF7E-435D-8960-F99683D2D49C}
Windows Communication Foundation (WCF)	{3D9AD99F-2412-4246-B90B-4EAA41C64699}
Windows Presentation Foundation (WPF)	{60DC8134-EBA5-43B8-BCC9-BB4BC16C2548}
Visual Database Tools	{C252FEB5-A946-4202-B1D4-9916A0590387}
Database	{A9ACE9BB-CECE-4E62-9AA4-C7E7C5BD2124}
Database (other project types)	{4F174C21-8C12-11D0-8340-0000F80270F8}
Test	{3AC096D0-A1C2-E12C-1390-A8335801FDAB}
Legacy (2003) Smart Device (C#)	{20D4826A-C6FA-45DB-90F4-C717570B9F32}
Legacy (2003) Smart Device (VB.NET)	{CB4CE8C6-1BDB-4DC7-A4D3-65A1999772F8}
Smart Device (C#)	{4D628B5B-2FBC-4AA6-8C16-197242AEB884}
Smart Device (VB.NET)	{68B1623D-7FB9-47D8-8664-7ECEA3297D4F}
Workflow (C#)	{14822709-B5A1-4724-98CA-57A101D1B079}
Workflow (VB.NET)	{D59BE175-2ED0-4C54-BE3D-CDAA9F3214C8}
Deployment Merge Module	{06A35CCD-C46D-44D5-987B-CF40FF872267}
Deployment Cab	{3EA9E505-35AC-4774-B492-AD1749C4943A}
Deployment Setup	{978C614F-708E-4E1A-B201-565925725DBA}
Deployment Smart Device Cab	{AB322303-2255-48EF-A496-5904EB18DA55}
Visual Studio Tools for Applications (VSTA)	{A860303F-1F3F-4691-B57E-529FC101A107}
Visual Studio Tools for Office (VSTO)	{BAA0C2D2-18E2-41B9-852F-F413020CAA33}
SharePoint Workflow	{F8810EC1-6754-47FC-A15F-DFABD2E3FA90}
XNA (Windows)	{6D335F3A-9D43-41b4-9D22-F6F17C4BE596}
XNA (XBox)	{2DF5C3F4-5A5F-47a9-8E94-23B4456F55E2}
XNA (Zune)	{D399B71A-8929-442a-A9AC-8BEC78BB2433}
SharePoint (VB.NET)	{EC05E597-79D4-47f3-ADA0-324C4F7C7484}
SharePoint (C#)	{593B0543-81F6-4436-BA1E-4747859CAAE2}
Silverlight	{A1591282-1198-4647-A2B1-27E5FF5F6F3B}
ASP.Net MVC Application	{603C0E0B-DB56-11DC-BE95-000D561079B0}


https://www.cnblogs.com/jackking/p/6220085.html

ProjectTypeGuids和Project 节点说明
<ProjectGuid>{BEF1F2C9-1903-4AC4-93BD-08452BFA37A3}</ProjectGuid>  当前项目Guid
<ProjectTypeGuids>{E3E379DF-F4C6-4180-9B81-6769533ABE47};{349c5851-65df-11da-9384-00065b846f21};{fae04ec0-301f-11d3-bf4b-00c04f79efbc}</ProjectTypeGuids>

　　　E3E379DF-F4C6-4180-9B81-6769533ABE47   Asp.net MVC 4.0

    　 349c5851-65df-11da-9384-00065b846f21　　　Web Application　

    　fae04ec0-301f-11d3-bf4b-00c04f79efbc      Windows C#

Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "JSoft.Application", "JSoft.Application\JSoft.Application.csproj", "{F2035EE2-B73D-4FB8-A433-CAB465DE6A2A}"
EndProject

  

FAE04EC0-301F-11D3-BF4B-00C04F79EFBC 项目类型即（Windows C#）

JSoft.Application\JSoft.Application.csproj 当前项目

F2035EE2-B73D-4FB8-A433-CAB465DE6A2A 当前JSoft.Application.csproj 的Guid

<ProjectGuid>{F2035EE2-B73D-4FB8-A433-CAB465DE6A2A}</ProjectGuid>

2.项目类型列表

Project Type Description                 Project Type Guid

Windows (C#)                             {FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}
Windows (VB.NET)                         {F184B08F-C81C-45F6-A57F-5ABD9991F28F}
Windows (Visual C++)                     {8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}
Web Application                          {349C5851-65DF-11DA-9384-00065B846F21}
Web Site                                 {E24C65DC-7377-472B-9ABA-BC803B73C61A}
Distributed System                       {F135691A-BF7E-435D-8960-F99683D2D49C}
Windows Communication Foundation (WCF)   {3D9AD99F-2412-4246-B90B-4EAA41C64699}
Windows Presentation Foundation (WPF)    {60DC8134-EBA5-43B8-BCC9-BB4BC16C2548}
Visual Database Tools                    {C252FEB5-A946-4202-B1D4-9916A0590387}
Database                                 {A9ACE9BB-CECE-4E62-9AA4-C7E7C5BD2124}
Database (other project types)           {4F174C21-8C12-11D0-8340-0000F80270F8}
Test                                     {3AC096D0-A1C2-E12C-1390-A8335801FDAB}
Legacy (2003) Smart Device (C#)          {20D4826A-C6FA-45DB-90F4-C717570B9F32}
Legacy (2003) Smart Device (VB.NET)      {CB4CE8C6-1BDB-4DC7-A4D3-65A1999772F8}
Smart Device (C#)                        {4D628B5B-2FBC-4AA6-8C16-197242AEB884}
Smart Device (VB.NET)                    {68B1623D-7FB9-47D8-8664-7ECEA3297D4F}
Workflow (C#)                            {14822709-B5A1-4724-98CA-57A101D1B079}
Workflow (VB.NET)                        {D59BE175-2ED0-4C54-BE3D-CDAA9F3214C8}
Deployment Merge Module                  {06A35CCD-C46D-44D5-987B-CF40FF872267}
Deployment Cab                           {3EA9E505-35AC-4774-B492-AD1749C4943A}
Deployment Setup                         {978C614F-708E-4E1A-B201-565925725DBA}
Deployment Smart Device Cab              {AB322303-2255-48EF-A496-5904EB18DA55}
Visual Studio Tools for Apps (VSTA)      {A860303F-1F3F-4691-B57E-529FC101A107}
Visual Studio Tools for Office (VSTO)    {BAA0C2D2-18E2-41B9-852F-F413020CAA33}
SharePoint Workflow                      {F8810EC1-6754-47FC-A15F-DFABD2E3FA90}
XNA (Windows)                            {6D335F3A-9D43-41b4-9D22-F6F17C4BE596}
XNA (XBox)                               {2DF5C3F4-5A5F-47a9-8E94-23B4456F55E2}
XNA (Zune)                               {D399B71A-8929-442a-A9AC-8BEC78BB2433}
SharePoint (VB.NET)                      {EC05E597-79D4-47f3-ADA0-324C4F7C7484}
SharePoint (C#)                          {593B0543-81F6-4436-BA1E-4747859CAAE2}
Silverlight                              {A1591282-1198-4647-A2B1-27E5FF5F6F3B}
ASP.NET MVC 1.0                          {603C0E0B-DB56-11DC-BE95-000D561079B0}
ASP.NET MVC 2.0                          {F85E285D-A4E0-4152-9332-AB1D724D3325}
ASP.NET MVC 3.0                          {E53F8FEA-EAE0-44A6-8774-FFD645390401}
ASP.NET MVC 4.0                          {E3E379DF-F4C6-4180-9B81-6769533ABE47}