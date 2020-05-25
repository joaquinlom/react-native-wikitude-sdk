package com.joaquinlom.wikitude;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.wikitude.architect.ArchitectView;
import com.wikitude.common.permission.PermissionManager;

import java.util.Arrays;

public class WikitudePrecheck extends Activity {

	private PermissionManager mPermissionManager;

	protected static final String TAG = "WikitudePrecheck";

	private String architectWorldURL = "";
	private String sdkKey = "";
	private boolean hasGeolocation = false;
	private boolean hasImageRecognition = false;
	private boolean hasInstantTracking = false;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_wikitude_precheck);
		this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_FULL_SENSOR);

		mPermissionManager = ArchitectView.getPermissionManager();

		Bundle extras = getIntent().getExtras();



		String[] permissions = this.hasGeolocation ?
				new String[]{Manifest.permission.CAMERA, Manifest.permission.ACCESS_FINE_LOCATION} :
				new String[]{Manifest.permission.CAMERA};


		mPermissionManager.checkPermissions(WikitudePrecheck.this, permissions, PermissionManager.WIKITUDE_PERMISSION_REQUEST, new PermissionManager.PermissionManagerCallback() {
			@Override
			public void permissionsGranted(int requestCode) {
				Log.i(TAG, "Permission Granted, proceeding to start wikitude intent.");
				startWikitudeIntent();
			}

			@Override
			public void permissionsDenied(String[] deniedPermissions) {
				Toast.makeText(WikitudePrecheck.this, "The following permissions are required to enable an AR experience: " + Arrays.toString(deniedPermissions), Toast.LENGTH_SHORT).show();
			}

			@Override
			public void showPermissionRationale(final int requestCode, final String[] permissions) {
				AlertDialog.Builder alertBuilder = new AlertDialog.Builder(WikitudePrecheck.this);
				alertBuilder.setCancelable(true);
				alertBuilder.setTitle("AR Experience Permissions");
				alertBuilder.setMessage("The following permissions are required to enable an AR experience: " + Arrays.toString(permissions));
				alertBuilder.setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						mPermissionManager.positiveRationaleResult(requestCode, permissions);
					}
				});

				AlertDialog alert = alertBuilder.create();
				alert.show();
			}
		});

	}

  @Override
	public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
		mPermissionManager.onRequestPermissionsResult(requestCode, permissions, grantResults);
	}


	private void startWikitudeIntent()
	{


	}

	@Override
	protected void onActivityResult(int aRequestCode, int aResultCode, Intent aData)
	{
		super.onActivityResult(aRequestCode, aResultCode, aData);

		Log.i(TAG, "Got activity result code "+Integer.toString(aResultCode) + "");

		if (aRequestCode == 0xe110)
		{
			Log.i(TAG, "Exiting.");
			this.finish();
		}

	}

}
