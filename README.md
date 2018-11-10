# RefEm

## Overview

RefEm is an Application that helps researcher to find back to back literature from a paper. We use two APIs:

1. Microsoft Cognitive Service Labs (MCSL) API. See more: https://docs.microsoft.com/en-us/azure/cognitive-services/academic-knowledge/paperentityattributes
2. Allen Institute's Semantic Scholar (SS) API. See more: http://api.semanticscholar.org/

MCSL API gives a lot of attributes data related to research paper, such as paper title, paper year, author name, citation count, DOI, and etc. The limitation of MCSL API is that it does not provide us with the citation paper title data.

On the other hand, SS API can provide the citation paper title data, but it can only accept query based on [S2PaperID | DOI | ArXivId]. So in order to get citation paper title, we retrieve DOI from MS API and then use SS API to provide us with citation paper data.