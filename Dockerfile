# Dockerfile for powerwall_exporter (assuming pre-compiled Go binary)

# Start with a minimal base image. Alpine is small and common.
FROM golang:1.20-alpine 

# Set the working directory inside the container
WORKDIR /app

# Create a non-root user and group for security
# -S creates a system user/group, -G adds user to group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the pre-compiled powerwall_exporter binary from your build context
# into the container's working directory.
# Also set the owner to the non-root user/group created above.
COPY --chown=appuser:appgroup powerwall_exporter .

# Ensure the binary is executable (COPY usually preserves permissions, but explicit doesn't hurt)
RUN chmod +x ./powerwall_exporter

# Switch to the non-root user
USER appuser

# Expose the port the exporter listens on.
# Replace 9584 with the actual port if it's different for your exporter.
EXPOSE 9584

# Define the entrypoint for the container.
# This will execute the powerwall_exporter binary when the container starts.
# Any arguments passed to `docker run` after the image name will be appended here.
ENTRYPOINT ["./powerwall_exporter"]
#ENTRYPOINT ["/bin/ash"]

# Optional: You could add default arguments using CMD if desired,
# but it's often better to pass configuration via `docker run`.
# Example: CMD ["--powerwall.address=192.168.1.100"]
