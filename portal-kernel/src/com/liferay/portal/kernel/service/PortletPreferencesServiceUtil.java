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

package com.liferay.portal.kernel.service;

import aQute.bnd.annotation.ProviderType;

import com.liferay.portal.kernel.bean.PortalBeanLocatorUtil;

/**
 * Provides the remote service utility for PortletPreferences. This utility wraps
 * <code>com.liferay.portal.service.impl.PortletPreferencesServiceImpl</code> and is an
 * access point for service operations in application layer code running on a
 * remote server. Methods of this service are expected to have security checks
 * based on the propagated JAAS credentials because this service can be
 * accessed remotely.
 *
 * @author Brian Wing Shun Chan
 * @see PortletPreferencesService
 * @generated
 */
@ProviderType
public class PortletPreferencesServiceUtil {

	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never modify this class directly. Add custom service methods to <code>com.liferay.portal.service.impl.PortletPreferencesServiceImpl</code> and rerun ServiceBuilder to regenerate this class.
	 */
	public static void deleteArchivedPreferences(long portletItemId)
		throws com.liferay.portal.kernel.exception.PortalException {

		getService().deleteArchivedPreferences(portletItemId);
	}

	/**
	 * Returns the OSGi service identifier.
	 *
	 * @return the OSGi service identifier
	 */
	public static String getOSGiServiceIdentifier() {
		return getService().getOSGiServiceIdentifier();
	}

	public static void restoreArchivedPreferences(
			long groupId, com.liferay.portal.kernel.model.Layout layout,
			String portletId, long portletItemId,
			javax.portlet.PortletPreferences jxPortletPreferences)
		throws com.liferay.portal.kernel.exception.PortalException {

		getService().restoreArchivedPreferences(
			groupId, layout, portletId, portletItemId, jxPortletPreferences);
	}

	public static void restoreArchivedPreferences(
			long groupId, com.liferay.portal.kernel.model.Layout layout,
			String portletId,
			com.liferay.portal.kernel.model.PortletItem portletItem,
			javax.portlet.PortletPreferences jxPortletPreferences)
		throws com.liferay.portal.kernel.exception.PortalException {

		getService().restoreArchivedPreferences(
			groupId, layout, portletId, portletItem, jxPortletPreferences);
	}

	public static void restoreArchivedPreferences(
			long groupId, String name,
			com.liferay.portal.kernel.model.Layout layout, String portletId,
			javax.portlet.PortletPreferences jxPortletPreferences)
		throws com.liferay.portal.kernel.exception.PortalException {

		getService().restoreArchivedPreferences(
			groupId, name, layout, portletId, jxPortletPreferences);
	}

	public static void updateArchivePreferences(
			long userId, long groupId, String name, String portletId,
			javax.portlet.PortletPreferences jxPortletPreferences)
		throws com.liferay.portal.kernel.exception.PortalException {

		getService().updateArchivePreferences(
			userId, groupId, name, portletId, jxPortletPreferences);
	}

	public static PortletPreferencesService getService() {
		if (_service == null) {
			_service = (PortletPreferencesService)PortalBeanLocatorUtil.locate(
				PortletPreferencesService.class.getName());
		}

		return _service;
	}

	private static PortletPreferencesService _service;

}