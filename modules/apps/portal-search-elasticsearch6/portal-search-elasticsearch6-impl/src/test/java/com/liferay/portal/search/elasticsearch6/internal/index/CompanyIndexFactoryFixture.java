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

package com.liferay.portal.search.elasticsearch6.internal.index;

import com.liferay.portal.json.JSONFactoryImpl;
import com.liferay.portal.kernel.test.util.RandomTestUtil;
import com.liferay.portal.search.elasticsearch6.internal.connection.ElasticsearchFixture;
import com.liferay.portal.search.elasticsearch6.internal.connection.IndexName;

import org.elasticsearch.client.AdminClient;

/**
 * @author Adam Brandizzi
 */
public class CompanyIndexFactoryFixture {

	public CompanyIndexFactoryFixture(
		ElasticsearchFixture elasticsearchFixture, String indexName) {

		_elasticsearchFixture = elasticsearchFixture;
		_indexName = indexName;
	}

	public void createIndices() throws Exception {
		CompanyIndexFactory companyIndexFactory = getCompanyIndexFactory();

		AdminClient adminClient = _elasticsearchFixture.getAdminClient();

		companyIndexFactory.createIndices(
			adminClient, RandomTestUtil.randomLong());
	}

	public CompanyIndexFactory getCompanyIndexFactory() {
		return new CompanyIndexFactory() {
			{
				indexNameBuilder = new TestIndexNameBuilder();
				jsonFactory = new JSONFactoryImpl();
			}
		};
	}

	public String getIndexName() {
		IndexName indexName = new IndexName(_indexName);

		return indexName.getName();
	}

	protected class TestIndexNameBuilder implements IndexNameBuilder {

		@Override
		public String getIndexName(long companyId) {
			return CompanyIndexFactoryFixture.this.getIndexName();
		}

	}

	private final ElasticsearchFixture _elasticsearchFixture;
	private final String _indexName;

}