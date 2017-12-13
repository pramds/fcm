%dw 1.0
%output application/java
---
payload map {	
	entity: {
		externalId: $.order.soldToAccount ++ "_" ++ $.order.subsidiaryCode,
		type: 'CUSTOMER'
	},
	(tranDate: $.order.orderDate as :datetime) when $.order.orderDate != null,
	externalId: $.order.orderId,
	otherRefNum: $.order.poNumber,
	
	tranId: $.order.orderNumber,
	currency: {
		externalId: $.order.strCurrency
	},
	//email: $.order.billToContactEmail,
	subsidiary: {
		externalId : $.order.subsidiaryCode
	},
	(terms: {
		externalId : $.order.paymentTerms
	}) when $.order.paymentTerms !=null,
	isMultiShipTo: true,
	memo: $.order.externalInvoiceMemo,
	customFieldList: {
		customField: [{
			(SelectCustomFieldRef__custbody_fcm_shiptoaccount: {
				externalId: $.order.shipToAccount ++ "_" ++ $.order.subsidiaryCode
			}) when $.order.shipToAccount !=null,
			(SelectCustomFieldRef__custbody_fcm_soldtoaccount: {
				externalId: $.order.soldToAccount ++ "_" ++ $.order.subsidiaryCode
			})when $.order.soldToAccount !=null,
			(SelectCustomFieldRef__custbody_fcm_ordertype: {
				externalId: $.order.orderType
			})when $.order.orderType !=null,
			(SelectCustomFieldRef__custbody_fcm_tieronepartner: {
				(externalId: $.order.tier1Partner ++ "_" ++ $.order.subsidiaryCode)when $.order.tier1Partner !=null
			}),	
			(SelectCustomFieldRef__custbody_fcm_tieronerelationship: {
				externalId: $.order.tier1Relationship
			}) when $.order.tier1Relationship !=null,
			(SelectCustomFieldRef__custbody_fcm_tiertwopartner: {
				(externalId: $.order.tier2Partner ++ "_" ++ $.order.subsidiaryCode)when $.order.tier2Partner !=null
			}),
			(SelectCustomFieldRef__custbody_fcm_tiertworelationship: {
				externalId: $.order.tier2Relationship
			}) when $.order.tier2Relationship !=null,
			SelectCustomFieldRef__custbody_fcm_source_system: {
				externalId: 'Apttus'
			},	
			(StringCustomFieldRef__custbody_fcm_apttusquotenumber: $.order.proposalName) when $.order.proposalName !=null,
//			(StringCustomFieldRef__custbody_fcm_soldtoaddr1: address.street)when address.street !=null,
//			(StringCustomFieldRef__custbody_fcm_soldtoaddressee: address.street)when address.street !=null,
//			(StringCustomFieldRef__custbody_fcm_soldtocity: address.city) when address.city !=null,
//			(StringCustomFieldRef__custbody_fcm_soldtozip: address.postalCode) when address.postalCode !=null,
//	(SelectCustomFieldRef__custbody_fcm_soldtocountry: {
//			externalId: lookup("countriesLookUp",flowVars.countries[address.netSuiteCountryISOCode]) replace  "\"" with ""
//	})when address.netSuiteCountryISOCode !=null,
//	SelectCustomFieldRef__custbody_fcm_soldtoState: {
//		externalId: address.state	
//	},
	(StringCustomFieldRef__custbody_fcm_soldtophone: $.order.phone)when $.order.phone !=null,
	(SelectCustomFieldRef__custbody_fcm_channelroute: {
			externalId: $.order.marketRoute
	}) when $.order.marketRoute !=null,			
	salesRep: {
		externalId: $.order.salesRepEmpNum when $.order.marketRoute == "FORNAX" otherwise null
	},
	(MultiSelectCustomFieldRef__custbody_fcm_mainbusinessunit: {
			externalId: $.order.businessUnit
	})when $.order.lineOfBusiness !=null,
	(SelectCustomFieldRef__custbody_fcm_region: {
				externalId: $.order.region
	})when $.order.geography != null,
	(StringCustomFieldRef__custbody_fcm_sfdc_opportunitynumber: $.order.opportunityId) when $.order.opportunityId !=null,
	//(DateCustomFieldRef__custbody_fcm_quoteinvalidationdate: $.order.quoteInValidationDate as :datetime) when $.order.quoteInValidationDate !=null,
	(SelectCustomFieldRef__custbody_fcm_ordersubtype:{				
		externalId: $.order.addOnSubType
	})when $.order.addOnSubType !=null,
	(SelectCustomFieldRef__custbody_fcm_enduser: {
			externalId: $.order.endCustomer ++ "_" ++ $.order.subsidiaryCode
	})when $.order.endCustomer != null,
	(SelectCustomFieldRef__custbody_fcm_billtocontact: {
			externalId: $.order.billtoContact ++ "_" ++ $.order.soldToAccount ++ "_" ++ $.order.subsidiaryCode
	}) when $.order.billtoContact !=null,
	(StringCustomFieldRef__custbody_fcm_poamount: $.order.poAmount) when $.order.poAmount !=null,
	(StringCustomFieldRef__custcol_fcm_cpqorderid: $.order.poAmount) when $.order.poAmount !=null,
	(StringCustomFieldRef__custcol_fcm_cpqordernumber: $.order.poAmount) when $.order.poAmount !=null,
	(DateCustomFieldRef__custbody_fcm_postartdate: $.order.poDate as :datetime) when $.order.poDate !=null
}]},
		itemList: {
			item: ($.order.orderLineItems  map (orderPayload02, indexOfOrderPayload02)->{
				(rate: orderPayload02.netUnitPrice as :number / orderPayload02.quantity) when orderPayload02.netUnitPrice != null and orderPayload02.quantity != null,
					quantity: orderPayload02.remainingQuantity when ($.orderType == "TERMINATION"  and orderPayload02.remainingQuantity > 0) otherwise orderPayload02.quantity,
					amount: orderPayload02.netPrice,
				item: {
				(externalId: orderPayload02.productId) when orderPayload02.lineType == "Product/Service",
				(externalId: orderPayload02.optionId) when orderPayload02.lineType == "Option"
			},
			price: {
				externalId: '-1'
			},
			description: orderPayload02.description,
			(clazz: {
				externalId : orderPayload02.productLine
			}) when orderPayload02.productLine !=null,

			"customFieldList": {
				"customField": [{
				
					(DateCustomFieldRef__custcol_fcm_enddate: orderPayload02.endDate as :datetime) when (orderPayload02.endDate != null and (orderPayload02.productType == "EDU_SERVICES" or orderPayload02.productType == "SERVICES")),
					(DateCustomFieldRef__custcol_fcm_startdate: orderPayload02.startDate as :datetime) when (orderPayload02.startDate != null and (orderPayload02.productType == "EDU_SERVICES" or orderPayload02.productType == "SERVICES")),
					(StringCustomFieldRef__custcol_fcm_ic_gross_amt: orderPayload02.extendedListPrice) when orderPayload02.extendedListPrice !=null,
					(StringCustomFieldRef__custcol_fcm_apttusordernumber : $.order.orderNumber) when ($.order.orderNumber != null),
					(StringCustomFieldRef__custcol_fcm_contractterm : orderPayload02.sellingTerm) when (orderPayload02.sellingTerm != null),
					(SelectCustomFieldRef__custcol_fcm_relatedlicense: {
						(externalId:orderPayload02.productCode) when orderPayload02.productCode !=null,
						(externalId:orderPayload02.optionProductCode) when  orderPayload02.optionProductCode  !=null
					}) when orderPayload02.optionSupport == "true",
					(StringCustomFieldRef__custcol_fcm_contractualdiscountamount: orderPayload02.contractualDiscountAmount) when orderPayload02.contractualDiscountAmount !=null,
					(StringCustomFieldRef__custcol_fcm_contractualdiscountpercen: orderPayload02.contractualDiscountPercentage) when orderPayload02.contractualDiscountPercentage !=null,
					(StringCustomFieldRef__custcol_fcm_pormotionaldiscountpercen: orderPayload02.promotionalDiscountPercentage) when orderPayload02.promotionalDiscountPercentage !=null,
					(StringCustomFieldRef__custcol_fcm_promotionaldiscountamount: orderPayload02.promotionDiscountAmount) when orderPayload02.promotionDiscountAmount !=null,
					(StringCustomFieldRef__custcol_fcm_partnerdiscountpercent: orderPayload02.programDiscountPercentage) when orderPayload02.programDiscountPercentage !=null,
					(StringCustomFieldRef__custcol_fcm_partnerdiscountamount: orderPayload02.programDiscountAmount) when orderPayload02.programDiscountAmount !=null,
					(StringCustomFieldRef__custcol_fcm_additionaldiscountpercent: orderPayload02.additionalDiscountPercentage) when orderPayload02.additionalDiscountPercentage !=null,
					(StringCustomFieldRef__custcol_fcm_additionaldiscountamount: orderPayload02.additionalDiscountAmount) when orderPayload02.additionalDiscountAmount !=null,
					(SelectCustomFieldRef__custcol_cseg_fcm_profit_ctr: {
						externalId: orderPayload02.profitCentre
					}) when orderPayload02.profitCentre !=null,
				(StringCustomFieldRef__custcol_fcm_lineitemid: orderPayload02.lineItemId) when orderPayload02.lineItemId !=null,
				(SelectCustomFieldRef__custcol_fcm_chargetype: {
						externalId: orderPayload02.chargeType
					}) when orderPayload02.chargeType !=null,
				(StringCustomFieldRef__custcol_fcm_assetid: orderPayload02.assetNumber) when orderPayload02.assetNumber !=null,
					(SelectCustomFieldRef__custcol_fcm_billingfrequency: {
						externalId: orderPayload02.billingFrequency
					}) when orderPayload02.billingFrequency !=null,
					(SelectCustomFieldRef__custcol_fcm_billingplan: {
						externalId:  orderPayload02.billingPlan
					})when (orderPayload02.billingPlan != null),
					(StringCustomFieldRef__custcol_fcm_upliftamount : orderPayload02.upliftAmount) when (orderPayload02.upliftAmount != null),
					(StringCustomFieldRef__custcol_fcm_upliftpercent : orderPayload02.upliftPercentage) when (orderPayload02.upliftPercentage != null),
					(StringCustomFieldRef__custcol_fcm_ponumber : $.order.poNumber) when ($.order.poNumber != null),
					(StringCustomFieldRef__custcol_fcm_unitlistprice: orderPayload02.extendedListPrice/orderPayload02.quantity) when orderPayload02.extendedListPrice != null and orderPayload02.quantity != null,
					(StringCustomFieldRef__custcol_fcm_displayquantity: orderPayload02.quantity) when orderPayload02.quantity !=null
					
				}]
			}		
	
		})
	}
	
	}