<AppName>
<p>An application that helps researcher to find back to back literature from a paper.<br>
Given a paper information, we use data that we collected from API to find the best papers that it cites <b>(best reference paper)</b>, and the best papers that cite it<b> (best citation paper)</b>. We then create a before/after <b>citation map of a paper</b>. <br>
The best papers citation and reference policy will be part of our business logic (under development), probably will be based on the weight of <b>citation number</b> and the <b>paper venue</b>.
  </p>
<h2>Overview</h2>

In this app we use 2 APIs: 
<ol>
  <li><a href="https://docs.microsoft.com/en-us/azure/cognitive-services/academic-knowledge/paperentityattributes">Microsoft Cognitive Service Labs (MCSL) API</a></li>
  <li><a href="http://api.semanticscholar.org/">Allen Institute's Semantic Scholar (SS) API</a></li>
</ol>
<p>MCSL API gives a lot of attributes data related to research paper, such as <b>paper title, paper year, author name, citation count, DOI,</b> and etc. The limitation of MCSL API is that it does not provide us with the <b>citation paper title</b> data. 
</p>
<p>On the other hand, SS API can provide the <b>citation paper title</b> data, but it can only accept query based on <b>[S2PaperID | DOI | ArXivId]</b>. So in order to get <b>citation paper title</b>, we retrieve </b>DOI</b> from MS API and then use SS API to provide us with citation paper data.
</p>
