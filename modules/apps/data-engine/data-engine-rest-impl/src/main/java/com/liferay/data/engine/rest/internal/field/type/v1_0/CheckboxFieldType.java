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

package com.liferay.data.engine.rest.internal.field.type.v1_0;

import com.liferay.data.engine.rest.dto.v1_0.DataDefinitionField;
import com.liferay.data.engine.rest.internal.dto.v1_0.util.LocalizedValueUtil;
import com.liferay.data.engine.rest.internal.field.type.v1_0.util.CustomPropertyUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.template.soy.data.SoyDataFactory;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Marcela Cunha
 */
public class CheckboxFieldType extends BaseFieldType {

	public CheckboxFieldType(
		DataDefinitionField dataDefinitionField,
		HttpServletRequest httpServletRequest,
		HttpServletResponse httpServletResponse,
		SoyDataFactory soyDataFactory) {

		super(
			dataDefinitionField, httpServletRequest, httpServletResponse,
			soyDataFactory);
	}

	@Override
	public DataDefinitionField deserialize(JSONObject jsonObject)
		throws Exception {

		DataDefinitionField dataDefinitionField = super.deserialize(jsonObject);

		dataDefinitionField.setCustomProperties(
			CustomPropertyUtil.add(
				dataDefinitionField.getCustomProperties(), "showAsSwitcher",
				jsonObject.getBoolean("showAsSwitcher")));
		dataDefinitionField.setDefaultValue(
			LocalizedValueUtil.toLocalizedValues(
				jsonObject.getJSONObject("predefinedValue")));

		return dataDefinitionField;
	}

	@Override
	public JSONObject toJSONObject() throws Exception {
		JSONObject jsonObject = super.toJSONObject();

		return jsonObject.put(
			"predefinedValue",
			LocalizedValueUtil.toJSONObject(
				dataDefinitionField.getDefaultValue())
		).put(
			"showAsSwitcher",
			CustomPropertyUtil.getBoolean(
				dataDefinitionField.getCustomProperties(), "showAsSwitcher",
				true)
		);
	}

	@Override
	protected void addContext(Map<String, Object> context) {
		context.put(
			"predefinedValue",
			LocalizedValueUtil.getLocalizedValue(
				httpServletRequest.getLocale(),
				dataDefinitionField.getDefaultValue()));
		context.put(
			"showAsSwitcher",
			CustomPropertyUtil.getBoolean(
				dataDefinitionField.getCustomProperties(), "showAsSwitcher",
				false));
		context.put(
			"value",
			CustomPropertyUtil.getBoolean(
				dataDefinitionField.getCustomProperties(), "value", false));
	}

}