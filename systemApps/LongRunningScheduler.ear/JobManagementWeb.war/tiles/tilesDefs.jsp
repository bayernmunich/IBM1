

<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<tiles:definition
    id="job.collection.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobCollectionViewTitle" />
    <tiles:put name="description"  value="jobCollectionViewDesc" />
    <tiles:put name="script"       value="/tiles/jobCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_view_jobs.html" />
    <tiles:put name="content"      value="job.collection.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>


<tiles:definition
    id="job.collection.view.content"
    page="/tiles/collection.jsp">
    <tiles:put name="collectionName" value="JobCollectionForm" />
    <tiles:put name="action"         value="viewJobs" />
    <tiles:put name="detailAction"   value="viewJobLog.do?action=view" />
    <tiles:put name="actionSection"  value="jobActions.jsp" />
    <tiles:put name="filterSection"  value="jobFilter.jsp" />
    <tiles:put name="refreshColumn"  value="jobCurrentState" />
    <tiles:putList name="propertyList">
        <tiles:add value="jobId" />
        <tiles:add value="jobSubmitter" />
        <tiles:add value="jobLastUpdate" />
        <tiles:add value="jobCurrentState" />
        <tiles:add value="jobNode" />
        <tiles:add value="jobAppServer" />
		<tiles:add value="jobGroup" />
    </tiles:putList>
</tiles:definition>


<tiles:definition
    id="job.log.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobLogViewTitle" />
    <tiles:put name="description"  value="jobLogViewDesc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_view_joblog.html" />
    <tiles:put name="content"      value="job.log.view.content"/>
    <tiles:put name="formName"     value="JobDetailForm" />
    <tiles:put name="refProp"      value="jobId" />
</tiles:definition>

<tiles:definition
    id="job.log.view.content"
    page="/tiles/jobLogContent.jsp">
</tiles:definition>


<tiles:definition
    id="saved.job.collection.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="savedJobCollectionViewTitle" />
    <tiles:put name="description"  value="savedJobCollectionViewDesc" />
    <tiles:put name="script"       value="/tiles/savedJobCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_view_saved_jobs.html" />
    <tiles:put name="content"      value="saved.job.collection.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="saved.job.collection.view.content"
    page="/tiles/collection.jsp">
    <tiles:put name="collectionName" value="SavedJobCollectionForm" />
    <tiles:put name="action"         value="viewSavedJobs" />
    <tiles:put name="detailAction"   value="viewSavedJobs.do?action=edit" />
    <tiles:put name="actionSection"  value="savedJobActions.jsp" />
    <tiles:put name="filterSection"  value="savedJobFilter.jsp" />
    <tiles:put name="refreshColumn"  value="" />
    <tiles:putList name="propertyList">
        <tiles:add value="jobName" />
		<tiles:add value="jobGroup" />
    </tiles:putList>
</tiles:definition>

<tiles:definition
    id="saved.job.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="savedJobViewTitle" />
    <tiles:put name="description"  value="savedJobViewDesc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_view_saved_jobcontent.html" />
    <tiles:put name="content"      value="saved.job.view.content"/>
    <tiles:put name="formName"     value="SavedJobDetailForm" />
    <tiles:put name="refProp"      value="jobName" />
</tiles:definition>

<tiles:definition
    id="saved.job.view.content"
    page="/tiles/savedJobContent.jsp">
</tiles:definition>

<tiles:definition
    id="schedule.collection.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobScheduleCollectionViewTitle" />
    <tiles:put name="description"  value="jobScheduleCollectionViewDesc" />
    <tiles:put name="script"       value="/tiles/jobScheduleCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_schedule.html" />
    <tiles:put name="content"      value="schedule.collection.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="schedule.collection.view.content"
    page="/tiles/collection.jsp">
    <tiles:put name="collectionName" value="JobScheduleCollectionForm" />
    <tiles:put name="action"         value="viewJobSchedules" />
    <tiles:put name="detailAction"   value="viewJobSchedules.do?action=edit" />
    <tiles:put name="actionSection"  value="jobScheduleActions.jsp" />
    <tiles:put name="filterSection"  value="jobScheduleFilter.jsp" />
    <tiles:put name="refreshColumn"  value="jobScheduleRequestId" />
    <tiles:putList name="propertyList">
        <tiles:add value="jobScheduleRequestId" />
        <tiles:add value="jobScheduleSubmitter" />
        <tiles:add value="jobScheduleStartDateTime" />
        <tiles:add value="jobScheduleInterval" />
		<tiles:add value="group" />
    </tiles:putList>
</tiles:definition>

<tiles:definition
    id="schedule.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobScheduleDetailViewTitle" />
    <tiles:put name="description"  value="jobScheduleDetailViewDesc" />
    <tiles:put name="script"       value="/tiles/jobScheduleScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_update_schedule.html" />
    <tiles:put name="content"      value="schedule.view.content"/>
    <tiles:put name="formName"     value="JobScheduleDetailForm" />
    <tiles:put name="refProp"      value="jobScheduleRequestId" />
</tiles:definition>

<tiles:definition
    id="schedule.view.content"
    page="/tiles/scheduleDetailView.jsp">
    <tiles:put name="detailName" value="JobScheduleDetailForm"/>
	<tiles:put name="action" value="viewJobSchedules"/>
</tiles:definition>

<tiles:definition
    id="save.job"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="saveJobTitle" />
    <tiles:put name="description"  value="saveJobDesc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_save.html" />
    <tiles:put name="content"      value="save.job.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="save.job.content"
    page="/tiles/saveJobContent.jsp">
</tiles:definition>

<tiles:definition
    id="submit.job.step1"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="submitJob" />
    <tiles:put name="description"  value="submitJobStep1Desc" />
    <tiles:put name="script"       value="/tiles/submitJobScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_submit_jobs.html" />
    <tiles:put name="content"      value="submit.job.step1.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="submit.job.step1.content"
    page="/tiles/submitJobStep1Content.jsp">
</tiles:definition>

<tiles:definition
    id="submit.job.step2"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="submitJob" />
    <tiles:put name="description"  value="submitJobStep2Desc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_submit_jobs.html" />
    <tiles:put name="content"      value="submit.job.step2.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="submit.job.step2.content"
    page="/tiles/submitJobStep2Content.jsp">
</tiles:definition>


<tiles:definition
    id="create.schedule.step1"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="createScheduleTitle" />
    <tiles:put name="description"  value="createScheduleDesc" />
    <tiles:put name="script"       value="/tiles/createScheduleScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_create_schedule.html" />
    <tiles:put name="content"      value="create.schedule.step1.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="create.schedule.step1.content"
    page="/tiles/createScheduleStep1Content.jsp">
</tiles:definition>

<tiles:definition
    id="create.schedule.step2"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="createScheduleTitle" />
    <tiles:put name="description"  value="createScheduleDesc" />
    <tiles:put name="script"       value="/tiles/createScheduleScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_create_schedule.html" />
    <tiles:put name="content"      value="create.schedule.step2.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="create.schedule.step2.content"
    page="/tiles/createScheduleStep2Content.jsp">
</tiles:definition>

<tiles:definition
    id="create.schedule.step21"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="createScheduleTitle" />
    <tiles:put name="description"  value="createScheduleDesc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_create_schedule.html" />
    <tiles:put name="content"      value="create.schedule.step21.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="create.schedule.step21.content"
    page="/tiles/createScheduleStep21Content.jsp">
</tiles:definition>

<tiles:definition
    id="create.schedule.step3"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="createScheduleTitle" />
    <tiles:put name="description"  value="createScheduleDesc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_create_schedule.html" />
    <tiles:put name="content"      value="create.schedule.step3.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="create.schedule.step3.content"
    page="/tiles/createScheduleStep3Content.jsp">
</tiles:definition>

<tiles:definition
    id="schedule.select.saved.job.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="createScheduleTitle" />
    <tiles:put name="description"  value="selectSavedJobDesc" />
    <tiles:put name="script"       value="/tiles/selectSavedJobCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_create_schedule.html" />
    <tiles:put name="content"      value="select.saved.job.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="update.schedule.select.saved.job.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobScheduleDetailViewTitle" />
    <tiles:put name="description"  value="selectSavedJobDesc" />
    <tiles:put name="script"       value="/tiles/selectSavedJobCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_update_schedule.html" />
    <tiles:put name="content"      value="select.saved.job.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="submit.select.saved.job.view"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="submitJob" />
    <tiles:put name="description"  value="selectSavedJobDesc" />
    <tiles:put name="script"       value="/tiles/selectSavedJobCollectionScript.jsp" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_submit_jobs.html" />
    <tiles:put name="content"      value="select.saved.job.view.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="select.saved.job.view.content"
    page="/tiles/selectSavedJobContent.jsp">
    <tiles:put name="collectionName" value="SavedJobCollectionForm" />
    <tiles:put name="filterSection"  value="savedJobFilter.jsp" />
    <tiles:putList name="propertyList">
        <tiles:add value="jobName" />
    </tiles:putList>
</tiles:definition>

<tiles:definition
    id="update.new.properties"
    page="/layouts/contentLayout.jsp">
    <tiles:put name="title"        value="jmc" />
    <tiles:put name="portletTitle" value="jobScheduleDetailViewTitle" />
    <tiles:put name="description"  value="submitJobStep2Desc" />
    <tiles:put name="script"       value="" />
    <tiles:put name="helpLink"     value="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_submit_jobs.html" />
    <tiles:put name="content"      value="update.new.properties.content"/>
    <tiles:put name="formName"     value="" />
    <tiles:put name="refProp"      value="" />
</tiles:definition>

<tiles:definition
    id="update.new.properties.content"
    page="/tiles/updateNewPropertiesContent.jsp">
</tiles:definition>

