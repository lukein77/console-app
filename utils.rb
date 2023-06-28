def get_current_time
    current_time = Time.now
    return current_time.strftime("%Y-%m-%d %H:%M:%S UTC%Z")
end