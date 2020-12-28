def load_frog_file(filepath):
    data = pd.read_csv(filepath, sep='\t', skiprows=(0,2))

    orig_cols = data.columns
    rename_cols = {}

    for search, new_col in [['Timestamp','Timestamp'],
                            ['Accel_LN_X', 'AccelX'], ['Accel_LN_Y', 'AccelY'], ['Accel_LN_Z', 'AccelZ'],
                            ['Skin_Conductance', 'EDA']]:
        orig = [c for c in orig_cols if search in c]
        if len(orig) == 0:
            continue
        rename_cols[orig[0]] = new_col

    data.rename(columns=rename_cols, inplace=True)

    # TODO: Assuming no temperature is recorded
    data['Temp'] = 0

    # Drop the units row and unnecessary columns
    data = data[data['Timestamp'] != 'ms']
    data.index = pd.to_datetime(data['Timestamp'], unit='ms')
    data = data[['AccelZ', 'AccelY', 'AccelX', 'Temp', 'EDA']]

    for c in ['AccelZ', 'AccelY', 'AccelX', 'Temp', 'EDA']:
        data[c] = pd.to_numeric(data[c])

    # Convert to 8Hz
    data = data.resample("125L").mean()
    data.interpolate(inplace=True)

    # Get the filtered data using a low-pass butterworth filter (cutoff:1hz, fs:8hz, order:6)
    data['filtered_eda'] = butter_lowpass_filter(data['EDA'], 1.0, 8, 6)

    return data