<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Total_Price</fullName>
        <description>Copy Total Price to Temp Total Price field</description>
        <field>Temp_Total_Price__c</field>
        <formula>Total_Price__c</formula>
        <name>Copy Total Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Total_Price_With_Discount_Rule</fullName>
        <description>Copy Total Price to Temp Total Price field with Discount</description>
        <field>Total_Price_With_Discount__c</field>
        <formula>Total_Price__c - Total_Price__c  *  Discount__c</formula>
        <name>Copy Total Price With Discount Rule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Total Price Rule</fullName>
        <actions>
            <name>Copy_Total_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL( Total_Price__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Total Price With Discount Rule</fullName>
        <actions>
            <name>Copy_Total_Price_With_Discount_Rule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL( Total_Price__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
