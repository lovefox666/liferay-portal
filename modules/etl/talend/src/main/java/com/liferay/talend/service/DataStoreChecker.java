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

package com.liferay.talend.service;

import com.liferay.talend.data.store.AuthenticationMethod;
import com.liferay.talend.data.store.BasicAuthDataStore;
import com.liferay.talend.data.store.GenericDataStore;
import com.liferay.talend.data.store.OAuth2DataStore;
import com.liferay.talend.http.client.exception.ConnectionException;
import com.liferay.talend.http.client.exception.MalformedURLException;
import com.liferay.talend.http.client.exception.OAuth2Exception;
import com.liferay.talend.util.StringUtils;

import java.net.URL;

import org.talend.sdk.component.api.configuration.Option;
import org.talend.sdk.component.api.service.Service;
import org.talend.sdk.component.api.service.healthcheck.HealthCheckStatus;

/**
 * @author Igor Beslic
 */
@Service
public class DataStoreChecker {

	public HealthCheckStatus checkBasicAuthDataStore(
		@Option GenericDataStore genericDataStore) {

		BasicAuthDataStore basicAuthDataStore =
			genericDataStore.getBasicAuthDataStore();

		if (!basicAuthDataStore.isAnonymous() &&
			(StringUtils.isNull(basicAuthDataStore.getUser()) ||
			 StringUtils.isNull(basicAuthDataStore.getPassword()))) {

			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO,
				"Username and password are required");
		}

		try {
			_connectionService.getResponseRawString(
				genericDataStore, "/c/portal/login");
		}
		catch (ConnectionException ce) {
			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO,
				"Connection failed, received HTTP response status " +
					ce.getMessage());
		}

		return new HealthCheckStatus(
			HealthCheckStatus.Status.OK, "Connection succeeded!");
	}

	public HealthCheckStatus checkGenericDataStore(
		GenericDataStore genericDataStore) {

		URL openAPISpecURL = genericDataStore.getOpenAPISpecURL();

		if (openAPISpecURL == null) {
			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO,
				"OpenAPI Specification URL is required");
		}

		try {
			_liferayService.validateOpenAPISpecURL(
				openAPISpecURL.toExternalForm());
		}
		catch (MalformedURLException murle) {
			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO, murle.getMessage());
		}

		if (genericDataStore.getAuthenticationMethod() ==
				AuthenticationMethod.OAUTH2) {

			return checkOAuth2DataStore(genericDataStore);
		}

		return checkBasicAuthDataStore(genericDataStore);
	}

	public HealthCheckStatus checkOAuth2DataStore(
		GenericDataStore genericDataStore) {

		OAuth2DataStore oAuth2DataStore = genericDataStore.getoAuth2DataStore();

		if (StringUtils.isNull(oAuth2DataStore.getConsumerKey()) ||
			StringUtils.isNull(oAuth2DataStore.getConsumerSecret())) {

			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO,
				"Consumer key and secret are required");
		}

		try {
			_connectionService.requestAuthorizationJsonObject(genericDataStore);
		}
		catch (OAuth2Exception oae) {
			return new HealthCheckStatus(
				HealthCheckStatus.Status.KO, oae.getMessage());
		}

		return new HealthCheckStatus(
			HealthCheckStatus.Status.OK, "Connection succeeded!");
	}

	@Service
	private ConnectionService _connectionService;

	@Service
	private LiferayService _liferayService;

}