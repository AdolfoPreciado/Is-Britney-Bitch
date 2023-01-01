clc
clear all
close all

fs=300;

ecg=load("A00003.mat");
ecg=ecg.val;
%%
[sqi]=ecg_analysis(ecg, fs);
