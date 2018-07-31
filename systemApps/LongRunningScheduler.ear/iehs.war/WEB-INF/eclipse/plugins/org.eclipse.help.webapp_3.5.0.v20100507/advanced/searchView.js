function clickTab(switchCommentTab){
	if(switchCommentTab){
		document.getElementById("iehsc-tab-topics").className = "iehsc-nonselected-tab";
		document.getElementById("iehsc-tab-comments").className = "iehsc-selected-tab";
		document.getElementById("topic-content").style.display = "none";
		document.getElementById("comment-content").style.display = "block";
	}else{
		document.getElementById("iehsc-tab-topics").className = "iehsc-selected-tab";
		document.getElementById("iehsc-tab-comments").className = "iehsc-nonselected-tab";
		document.getElementById("topic-content").style.display = "block";
		document.getElementById("comment-content").style.display = "none";
	}	
}

function scrollContent(similarDivId, similarLink){
	var similarDivContent = document.getElementById(similarDivId);
	if(similarDivContent){
		similarDivContent.style.display = (similarDivContent.style.display == "block")?"none":"block";
		similarLink.style.marginBottom = (similarDivContent.style.display == "block")?"0px":"5px";
	}
}
