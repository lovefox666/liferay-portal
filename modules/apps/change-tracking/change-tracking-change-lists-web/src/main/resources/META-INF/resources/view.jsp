<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
SearchContainer<CTCollection> ctCollectionSearchContainer = changeListsDisplayContext.getSearchContainer();

DisplayTerms displayTerms = ctCollectionSearchContainer.getDisplayTerms();

String title = LanguageUtil.get(request, "select-change-list");

portletDisplay.setTitle(title);
renderResponse.setTitle(title);
%>

<liferay-ui:success key='<%= portletDisplay.getPortletName() + "checkoutProductionSuccess" %>' message="production-checked-out-success-message" />

<clay:management-toolbar
	clearResultsURL="<%= changeListsDisplayContext.getViewSearchActionURL() %>"
	creationMenu="<%= changeListsDisplayContext.getCreationMenu() %>"
	filterDropdownItems="<%= changeListsDisplayContext.getFilterDropdownItems() %>"
	itemsTotal="<%= ctCollectionSearchContainer.getTotal() %>"
	searchActionURL="<%= changeListsDisplayContext.getViewSearchActionURL() %>"
	searchContainerId="changeLists"
	selectable="<%= false %>"
	showCreationMenu="<%= true %>"
	showSearch="<%= true %>"
	sortingOrder="<%= changeListsDisplayContext.getOrderByType() %>"
	sortingURL="<%= changeListsDisplayContext.getSortingURL() %>"
	viewTypeItems="<%= changeListsDisplayContext.getViewTypeItems() %>"
/>

<div class="container-fluid-1280 lfr-search-container-wrapper main-content-body">
	<c:choose>
		<c:when test='<%= Objects.equals(changeListsDisplayContext.getDisplayStyle(), "list") %>'>
			<liferay-ui:search-container
				id="changeLists"
				searchContainer="<%= ctCollectionSearchContainer %>"
			>
				<liferay-ui:search-container-row
					className="com.liferay.change.tracking.model.CTCollection"
					keyProperty="ctCollectionId"
					modelVar="curCTCollection"
				>

					<%
					boolean production = CTConstants.CT_COLLECTION_NAME_PRODUCTION.equals(curCTCollection.getName());
					%>

					<liferay-portlet:actionURL name="/change_lists/checkout_ct_collection" var="checkoutCollectionURL">
						<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
					</liferay-portlet:actionURL>

					<liferay-ui:search-container-column-text
						href="<%= checkoutCollectionURL.toString() %>"
						name="name"
					>
						<c:choose>
							<c:when test="<%= production %>">
								<span class="work-on-production"><liferay-ui:message key="work-on-production" /></span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(curCTCollection.getName()) %>
							</c:otherwise>
						</c:choose>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-date
						name="modified-date"
						value="<%= !production ? curCTCollection.getModifiedDate() : null %>"
					>
					</liferay-ui:search-container-column-date>

					<liferay-ui:search-container-column-text
						name="created-by"
					>
						<c:if test="<%= !production %>">
							<%= HtmlUtil.escape(curCTCollection.getUserName()) %>
						</c:if>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-text
						name="description"
					>
						<c:choose>
							<c:when test="<%= production %>">
								<span class="work-on-production-description"><liferay-ui:message key="your-changes-will-be-added-to-the-live-site-immediately" /></span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(curCTCollection.getDescription()) %>
							</c:otherwise>
						</c:choose>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-text
						name="status"
					>
						<c:if test="<%= changeListsDisplayContext.isChangeListActive(curCTCollection.getCtCollectionId()) %>">
							<span class="label label-info">
								<span class="label-item label-item-expand"><liferay-ui:message key="active" /></span>
							</span>
						</c:if>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-text>
						<liferay-ui:icon-menu
							direction="left-side"
							icon="<%= StringPool.BLANK %>"
							markupView="lexicon"
							showWhenSingleIcon="<%= true %>"
						>
							<c:if test="<%= !production %>">
								<liferay-portlet:renderURL var="editCollectionURL">
									<portlet:param name="mvcRenderCommandName" value="/change_lists/edit_ct_collection" />
									<portlet:param name="backURL" value="<%= themeDisplay.getURLCurrent() %>" />
									<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
								</liferay-portlet:renderURL>

								<liferay-ui:icon
									message="edit"
									url="<%= editCollectionURL %>"
								/>

								<liferay-portlet:renderURL var="publishModalURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
									<liferay-portlet:param name="mvcRenderCommandName" value="/change_lists/publish_modal" />
									<liferay-portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
								</liferay-portlet:renderURL>

								<liferay-ui:icon
									message="publish"
									onClick='<%= "javascript:" + renderResponse.getNamespace() + "handleClickPublish(\'" + publishModalURL.toString() + "\');" %>'
									url="#"
								/>

								<liferay-portlet:actionURL name="/change_lists/delete_ct_collection" var="deleteCollectionURL">
									<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
								</liferay-portlet:actionURL>

								<liferay-ui:icon
									message="delete"
									url="<%= deleteCollectionURL %>"
								/>
							</c:if>
						</liferay-ui:icon-menu>
					</liferay-ui:search-container-column-text>
				</liferay-ui:search-container-row>

				<liferay-ui:search-iterator
					markupView="lexicon"
				/>
			</liferay-ui:search-container>
		</c:when>
		<c:when test='<%= Objects.equals(changeListsDisplayContext.getDisplayStyle(), "icon") %>'>
			<liferay-ui:search-container
				id="changeLists"
				searchContainer="<%= ctCollectionSearchContainer %>"
			>
				<div class="row">

					<%
					CTCollection productionCTCollection = changeListsDisplayContext.getProductionCTCollection();
					%>

					<liferay-portlet:actionURL name="/change_lists/checkout_ct_collection" var="checkoutProductionURL">
						<portlet:param name="ctCollectionId" value="<%= String.valueOf(productionCTCollection.getCtCollectionId()) %>" />
					</liferay-portlet:actionURL>

					<c:if test="<%= (productionCTCollection != null) && (ctCollectionSearchContainer.getCur() == 1) && Validator.isNull(displayTerms.getKeywords()) %>">
						<div class="col-sm-4">
							<div class="border-left-green card select-card-sheet">
								<div class="card-row card-row-layout-fixed card-row-padded card-row-valign-top select-card-header">
									<div class="card-col-content lfr-card-details-column production-details-column">
										<a href="<%= checkoutProductionURL.toString() %>">
											<span class="card-h3" data-qa-id="headerSubTitle">
												<span class="work-on-production"><liferay-ui:message key="work-on-production" /></span>
											</span>
										</a>

										<div class="select-card-sheet-block">
											<span class="card-h4"><liferay-ui:message key="description" /></span>

											<div class="card-text" data-qa-id="description">
												<span class="work-on-production-description"><liferay-ui:message key="your-changes-will-be-added-to-the-live-site-immediately" /></span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:if>

					<liferay-ui:search-container-row
						className="com.liferay.change.tracking.model.CTCollection"
						keyProperty="ctCollectionId"
						modelVar="curCTCollection"
					>

						<%
						boolean production = CTConstants.CT_COLLECTION_NAME_PRODUCTION.equals(curCTCollection.getName());
						%>

						<liferay-portlet:actionURL name="/change_lists/checkout_ct_collection" var="checkoutCollectionURL">
							<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
						</liferay-portlet:actionURL>

						<c:if test="<%= !production %>">
							<div class="col-sm-4">
								<div class="border-left-blue card select-card-sheet">
									<div class="card-row card-row-layout-fixed card-row-padded card-row-valign-top select-card-header">
										<div class="card-col-content lfr-card-details-column">
											<a href="<%= checkoutCollectionURL.toString() %>">
												<span class="card-h3" data-qa-id="headerSubTitle">
													<%= HtmlUtil.escape(curCTCollection.getName()) %>
												</span>
											</a>

											<c:if test="<%= Validator.isNotNull(curCTCollection.getDescription()) %>">
												<div class="select-card-sheet-block">
													<span class="card-h4"><liferay-ui:message key="description" /></span>

													<div class="card-text" data-qa-id="description">
														<%= HtmlUtil.escape(curCTCollection.getDescription()) %>
													</div>
												</div>
											</c:if>

											<div class="select-card-sheet-block">
												<span class="card-h4"><liferay-ui:message key="created-by" /> & <liferay-ui:message key="modified-date" /></span>

												<div class="card-text" data-qa-id="created-by-modified-date">
													<%= curCTCollection.getUserName() + " - " + curCTCollection.getModifiedDate() %>
												</div>
											</div>

											<div class="select-card-sheet-block">
												<span class="card-h4"><liferay-ui:message key="changes" /></span>

												<%
												Map<Integer, Long> changeTypeCounts = changeListsDisplayContext.getCTCollectionChangeTypeCounts(curCTCollection.getCtCollectionId());
												%>

												<div class="changes-row">
													<div class="changes">
														<div class="big-number" data-qa-id="changesAdded">
															<%= changeTypeCounts.getOrDefault(CTConstants.CT_CHANGE_TYPE_ADDITION, 0L) %>
														</div>

														<div class=""><liferay-ui:message key="added" /></div>
													</div>

													<div class="changes">
														<div class="big-number" data-qa-id="changesModified">
															<%= changeTypeCounts.getOrDefault(CTConstants.CT_CHANGE_TYPE_MODIFICATION, 0L) %>
														</div>

														<div class=""><liferay-ui:message key="modified" /></div>
													</div>

													<div class="changes">
														<div class="big-number" data-qa-id="changesDeleted">
															<%= changeTypeCounts.getOrDefault(CTConstants.CT_CHANGE_TYPE_DELETION, 0L) %>
														</div>

														<div class=""><liferay-ui:message key="deleted" /></div>
													</div>
												</div>
											</div>
										</div>

										<div class="card-col-field lfr-card-actions-column">
											<liferay-ui:icon-menu
												direction="left-side"
												icon="<%= StringPool.BLANK %>"
												markupView="lexicon"
												showWhenSingleIcon="<%= true %>"
											>
												<liferay-portlet:renderURL var="editCollectionURL">
													<portlet:param name="mvcRenderCommandName" value="/change_lists/edit_ct_collection" />
													<portlet:param name="backURL" value="<%= themeDisplay.getURLCurrent() %>" />
													<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
												</liferay-portlet:renderURL>

												<liferay-ui:icon
													message="edit"
													url="<%= editCollectionURL %>"
												/>

												<liferay-portlet:renderURL var="publishModalURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
													<liferay-portlet:param name="mvcRenderCommandName" value="/change_lists/publish_modal" />
													<liferay-portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
												</liferay-portlet:renderURL>

												<liferay-ui:icon
													message="publish"
													onClick='<%= "javascript:" + renderResponse.getNamespace() + "handleClickPublish(\'" + publishModalURL.toString() + "\');" %>'
													url="#"
												/>

												<liferay-portlet:actionURL name="/change_lists/delete_ct_collection" var="deleteCollectionURL">
													<portlet:param name="ctCollectionId" value="<%= String.valueOf(curCTCollection.getCtCollectionId()) %>" />
												</liferay-portlet:actionURL>

												<liferay-ui:icon
													message="delete"
													url="<%= deleteCollectionURL %>"
												/>
											</liferay-ui:icon-menu>
										</div>
									</div>
								</div>
							</div>
						</c:if>
					</liferay-ui:search-container-row>
				</div>

				<liferay-ui:search-iterator
					markupView="lexicon"
				/>
			</liferay-ui:search-container>
		</c:when>
	</c:choose>
</div>

<script>
	Liferay.on(
		'<portlet:namespace/>refreshSelectChangeList',
		function(event) {
			setTimeout(
				function() {
					Liferay.Util.navigate('<%= PortletURLFactoryUtil.create(request, CTPortletKeys.CHANGE_LISTS_HISTORY, PortletRequest.RENDER_PHASE) %>');
				},
				1000);
	});

	function <portlet:namespace/>handleClickPublish(url) {
		this.event.preventDefault();
		this.event.stopPropagation();

		Liferay.Menu._INSTANCE._closeActiveMenu();

		Liferay.Util.openWindow(
			{
				dialog: {
					center: true,
					destroyOnHide: false,
					height: 400,
					modal: true,
					width: 500
				},
				dialogIframe: {
					bodyCssClass: 'dialog-with-footer'
				},
				id: '<portlet:namespace/>publishIconDialog',
				title: '<%= LanguageUtil.get(request, "publish-change-list") %>',
				uri: url,
				zIndex: 10000
			});
	}
</script>